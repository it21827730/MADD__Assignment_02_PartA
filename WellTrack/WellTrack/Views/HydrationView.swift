import SwiftUI
import CoreData

struct HydrationView: View {
    @StateObject private var viewModel = HydrationViewModel()
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \HydrationEntry.date, ascending: false)],
        animation: .default
    ) private var entries: FetchedResults<HydrationEntry>
    @State private var buttonScale: CGFloat = 1.0
    private let selectedDateKey = "selected_date_timestamp"
    @State private var selectedDate: Date = Date()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    todayTotalCard

                    addWaterButton

                    historySection
                }
                .padding(AppTheme.Spacing.l)
            }
            .navigationTitle("Hydration")
            .onAppear {
                let ts = UserDefaults.standard.double(forKey: selectedDateKey)
                if ts > 0 {
                    selectedDate = Date(timeIntervalSince1970: ts)
                }
                viewModel.updateTotal(for: selectedDate)
            }
            .appScreenBackground()
        }
    }

    private var todayTotalCard: some View {
        VStack(spacing: AppTheme.Spacing.s) {
            Text("Today's Total")
                .appCaptionStyle()
            Text("\(Int(viewModel.totalTodayMl)) ml")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(AppColors.accent)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, AppTheme.Spacing.xxl)
        .padding(.horizontal, AppTheme.Spacing.l)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .fill(GradientTheme.lavenderGradient)
        )
        .shadow(color: AppColors.shadow,
                radius: AppTheme.Elevation.card.radius,
                x: AppTheme.Elevation.card.x,
                y: AppTheme.Elevation.card.y)
    }

    private var addWaterButton: some View {
        Button {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                buttonScale = 0.9
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                viewModel.addWater(for: selectedDate)
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    buttonScale = 1.0
                }
            }
        } label: {
            Label("Add 250ml", systemImage: "plus.circle.fill")
                .font(AppTypography.body.weight(.semibold))
                .appPrimaryButtonStyle()
        }
        .scaleEffect(buttonScale)
        .animation(.smooth, value: buttonScale)
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.m) {
            Text("History")
                .appHeadingStyle()

            let calendar = Calendar.current
            let startOfDay = calendar.startOfDay(for: selectedDate)
            let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? selectedDate
            let dayEntries = entries.filter { entry in
                guard let date = entry.date else { return false }
                return date >= startOfDay && date < endOfDay
            }

            if dayEntries.isEmpty {
                Text("No entries yet. Start tracking your hydration!")
                    .appCaptionStyle()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 40)
            } else {
                ForEach(dayEntries) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            if let date = entry.date {
                                Text(date, style: .time)
                                    .appBodyStyle()
                                Text(date, style: .date)
                                    .appCaptionStyle()
                            } else {
                                Text("No date")
                                    .appBodyStyle()
                            }
                        }
                        Spacer()
                        Text("\(Int(entry.amount)) ml")
                            .appHeadingStyle()
                            .foregroundStyle(AppColors.accent)
                    }
                    .padding(AppTheme.Spacing.l)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                            .fill(AppColors.primaryBackground)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                            .stroke(AppColors.borderSubtle, lineWidth: 1)
                    )
                }
            }
        }
    }
}

#Preview {
    let container = NSPersistentContainer(name: "WellTrackModel")
    if let description = container.persistentStoreDescriptions.first {
        description.url = URL(fileURLWithPath: "/dev/null")
    }
    container.loadPersistentStores { _, _ in }
    let context = container.viewContext
    return HydrationView()
        .environment(\.managedObjectContext, context)
}
