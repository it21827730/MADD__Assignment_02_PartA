import SwiftUI
import Charts
import CoreData

struct InsightsView: View {
    @ObservedObject var moodViewModel: MoodViewModel
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \HydrationEntry.date, ascending: true)],
        animation: .default
    ) private var entries: FetchedResults<HydrationEntry>
    @Environment(\.managedObjectContext) private var context
    @AppStorage("daily_hydration_goal_ml") private var dailyGoal: Double = 2000
    @State private var chartOpacity: Double = 0
    @State private var showingAlert: Bool = false
    @State private var alertMessage: String = ""

    var weeklyData: [(date: Date, amount: Double)] {
        let calendar = Calendar.current
        let today = Date()
        var data: [(Date, Double)] = []

        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

            let dayEntries = entries.filter { entry in
                guard let entryDate = entry.date else { return false }
                return entryDate >= startOfDay && entryDate < endOfDay
            }
            let total = dayEntries.reduce(0) { $0 + $1.amount }
            data.append((date: startOfDay, amount: total))
        }

        return data.reversed()
    }

    /// Mood for the last 7 days (latest entry per day), mapped to a numeric score.
    var moodWeeklyData: [(date: Date, score: Int, mood: MoodViewModel.Mood)] {
        let calendar = Calendar.current
        let today = Date()
        var result: [(Date, Int, MoodViewModel.Mood)] = []

        for i in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: date)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date

            let dayEntries = moodViewModel.entries.filter { entry in
                entry.date >= startOfDay && entry.date < endOfDay
            }

            if let latest = dayEntries.sorted(by: { $0.date > $1.date }).first {
                let score = moodViewModel.score(for: latest.mood)
                result.append((startOfDay, score, latest.mood))
            } else {
                // No mood logged that day; use neutral as baseline.
                let score = moodViewModel.score(for: .neutral)
                result.append((startOfDay, score, .neutral))
            }
        }

        return result.reversed()
    }

    var averageHydration: Double {
        let total = weeklyData.reduce(0) { $0 + $1.amount }
        return total / Double(max(weeklyData.count, 1))
    }

    var motivationalMessage: String {
        if averageHydration >= 2000 {
            return "Great job staying hydrated! 🌟"
        } else if averageHydration >= 1500 {
            return "You're doing well! Keep it up! 💪"
        } else if averageHydration >= 1000 {
            return "Good progress! Aim for a bit more. 💧"
        } else {
            return "Let's increase your hydration today! 🚀"
        }
    }

    // Simple correlation: count days where hydration >= goal AND mood score >= 4
    private var correlationText: String {
        let calendar = Calendar.current
        // Build a quick lookup for hydration by day (startOfDay)
        let hydrationByDay = Dictionary(uniqueKeysWithValues: weeklyData.map { (Calendar.current.startOfDay(for: $0.date), $0.amount) })

        var aligned = 0
        var considered = 0

        for moodPoint in moodWeeklyData {
            let day = calendar.startOfDay(for: moodPoint.date)
            if let hydration = hydrationByDay[day] {
                considered += 1
                let goodHydration = hydration >= dailyGoal
                let goodMood = moodPoint.score >= 4
                if goodHydration && goodMood {
                    aligned += 1
                }
            }
        }

        if considered == 0 {
            return "Not enough data to compare hydration and mood yet."
        } else {
            return "Hydration and mood aligned on \(aligned)/\(considered) days."
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    motivationalCard

                    chartSection

                    moodChartSection
                }
                .padding(AppTheme.Spacing.l)
            }
            .navigationTitle("Insights")
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        seedDemoData()
                    } label: {
                        Label("Load Demo Data", systemImage: "tray.and.arrow.down.fill")
                    }

                    Button(role: .destructive) {
                        resetDemoData()
                    } label: {
                        Label("Reset Demo Data", systemImage: "trash")
                    }
                }
            }
            .onAppear {
                withAnimation(.easeIn(duration: 0.6)) {
                    chartOpacity = 1.0
                }
            }
            .alert("Done", isPresented: $showingAlert, actions: {
                Button("OK", role: .cancel) {}
            }, message: {
                Text(alertMessage)
            })
            .appScreenBackground()
        }
    }

    private var motivationalCard: some View {
        VStack(spacing: AppTheme.Spacing.s) {
            Text(motivationalMessage)
                .appTitleMediumStyle()
                .multilineTextAlignment(.center)
            Text("Weekly Average: \(Int(averageHydration)) ml")
                .appCaptionStyle()
        }
        .frame(maxWidth: .infinity)
        .padding(AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .fill(GradientTheme.lavenderGradient)
        )
        .shadow(color: AppColors.shadow,
                radius: AppTheme.Elevation.card.radius,
                x: AppTheme.Elevation.card.x,
                y: AppTheme.Elevation.card.y)
    }

    private var chartSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.m) {
            Text("Last 7 Days")
                .appHeadingStyle()

            Chart {
                ForEach(weeklyData, id: \.date) { data in
                    BarMark(
                        x: .value("Amount", data.amount),
                        y: .value("Day", data.date)
                    )
                    .foregroundStyle(GradientTheme.mintAccentGradient)
                    .cornerRadius(8)
                }
            }
            .frame(height: 240)
            .chartXAxis {
                AxisMarks(position: .bottom) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartYAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                }
            }
            .opacity(chartOpacity)
            .animation(.easeIn(duration: 0.6), value: chartOpacity)
        }
        .padding(AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .fill(AppColors.primaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .stroke(AppColors.borderSubtle, lineWidth: 1)
        )
    }

    private var moodChartSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.m) {
            Text("Mood Trend (7 Days)")
                .appHeadingStyle()

            Chart {
                ForEach(moodWeeklyData, id: \.date) { data in
                    LineMark(
                        x: .value("Day", data.date),
                        y: .value("Mood", data.score)
                    )
                    PointMark(
                        x: .value("Day", data.date),
                        y: .value("Mood", data.score)
                    )
                    .foregroundStyle(by: .value("Mood", data.mood.label))
                }
            }
            .frame(height: 240)
            .chartYScale(domain: 1...5)
            .chartYAxis {
                AxisMarks(values: [1, 2, 3, 4, 5]) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel()
                }
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(format: .dateTime.day().month(.abbreviated))
                }
            }

            // Correlation note
            Text(correlationText)
                .appCaptionStyle()
        }
        .padding(AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .fill(AppColors.primaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .stroke(AppColors.borderSubtle, lineWidth: 1)
        )
    }

    // MARK: - Demo Utilities

    private func seedDemoData() {
        let calendar = Calendar.current
        let today = Date()

        // Seed hydration: realistic totals per day by adding several entries
        let hydrationTargets: [Double] = [
            1200, 1500, 1800, 1600, 2000, 2200, 2400
        ].reversed() // so the earliest day gets the first value

        for i in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let startOfDay = calendar.startOfDay(for: day)
            let target = hydrationTargets[i]

            // Break target into 4–6 entries across the day
            let chunks = Int.random(in: 4...6)
            let perChunk = target / Double(chunks)
            for _ in 0..<chunks {
                let offsetHours = Int.random(in: 7...21)
                let offsetMinutes = Int.random(in: 0...59)
                if let ts = calendar.date(byAdding: .hour, value: offsetHours, to: startOfDay)?
                    .addingTimeInterval(TimeInterval(offsetMinutes * 60)) {
                    CoreDataManager.shared.addEntry(amount: perChunk, date: ts)
                }
            }
        }

        // Seed moods: distribute across spectrum
        let moods: [MoodViewModel.Mood] = [.verySad, .sad, .neutral, .happy, .veryHappy, .happy, .neutral].reversed()
        var newMoodEntries: [MoodViewModel.MoodEntry] = []
        for i in 0..<7 {
            guard let day = calendar.date(byAdding: .day, value: -i, to: today) else { continue }
            let dateAtNoon = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: day) ?? day
            let mood = moods[i]
            let entry = MoodViewModel.MoodEntry(id: UUID(), date: dateAtNoon, mood: mood, note: "Demo \(mood.label.lowercased())")
            newMoodEntries.append(entry)
        }
        // Overwrite existing moods with demo set
        moodViewModel.entries = newMoodEntries.sorted { $0.date < $1.date }
        // Persist via MoodViewModel's storage key
        do {
            let data = try JSONEncoder().encode(moodViewModel.entries)
            UserDefaults.standard.set(data, forKey: "mood_entries")
        } catch {
            // ignore for demo
        }

        alertMessage = "Demo data loaded: last 7 days of hydration and moods."
        showingAlert = true
    }

    private func resetDemoData() {
        // Delete all hydration entries
        let fetch: NSFetchRequest<NSFetchRequestResult> = HydrationEntry.fetchRequest()
        let batchDelete = NSBatchDeleteRequest(fetchRequest: fetch)
        do {
            try context.execute(batchDelete)
            try context.save()
        } catch {
            // Fallback to iterating if batch delete fails
            if let all = try? context.fetch(HydrationEntry.fetchRequest()) {
                all.forEach { context.delete($0) }
                try? context.save()
            }
        }

        // Clear moods
        moodViewModel.entries = []
        UserDefaults.standard.removeObject(forKey: "mood_entries")

        alertMessage = "Demo data reset. Charts will reflect empty or neutral data."
        showingAlert = true
    }
}

#Preview {
    InsightsView(moodViewModel: MoodViewModel())
        .environment(\.managedObjectContext, CoreDataManager.shared.viewContext)
}
