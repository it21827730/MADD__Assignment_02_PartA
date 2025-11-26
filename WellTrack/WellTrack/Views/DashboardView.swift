import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @AppStorage("daily_hydration_goal_ml") private var storedDailyGoal: Double = 2000
    private let selectedDateKey = "selected_date_timestamp"
    @State private var selectedDate: Date = Date()
    @State private var animatedProgress: Double = 0

    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                datePickerSection
                header

                hydrationRing

                actions

                stepsCard
            }
            .padding(AppTheme.Spacing.l)
        }
        .appScreenBackground()
        .onAppear {
            // Load selected date from storage (defaults to today if not set)
            let ts = UserDefaults.standard.double(forKey: selectedDateKey)
            if ts > 0 {
                selectedDate = Date(timeIntervalSince1970: ts)
            }
            // Sync stored goal into the view model when the dashboard appears
            if storedDailyGoal > 0 {
                viewModel.dailyGoalMl = storedDailyGoal
            }
            // In previews, skip HealthKit to avoid preview crashes and use mock data instead.
            #if DEBUG
            let isPreview = ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
            #else
            let isPreview = false
            #endif

            if isPreview {
                viewModel.refreshMockData()
            } else {
                // Request HealthKit access and fetch today's stats. Falls back to mock if not granted.
                Task {
                    await viewModel.setupHealthKit()
                }
            }
            withAnimation(.easeInOut(duration: 0.8)) {
                animatedProgress = viewModel.progress
            }
        }
        .onChange(of: selectedDate) { _, newValue in
            UserDefaults.standard.set(newValue.timeIntervalSince1970, forKey: selectedDateKey)
        }
        .onChange(of: storedDailyGoal) { _, newValue in
            if newValue > 0 {
                viewModel.dailyGoalMl = newValue
            }
        }
        .onChange(of: viewModel.progress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }

    private var datePickerSection: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
            Text("Select Date")
                .appCaptionStyle()
            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var header: some View {
        VStack(spacing: AppTheme.Spacing.s) {
            Text("Dashboard")
                .appTitleLargeStyle()
            Text("Your daily overview")
                .appCaptionStyle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var hydrationRing: some View {
        VStack(spacing: AppTheme.Spacing.m) {
            ZStack {
                Circle()
                    .stroke(AppColors.borderSubtle, lineWidth: 18)

                Circle()
                    .trim(from: 0, to: animatedProgress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [Color(hex: "#ECE9F7"), Color(hex: "#A58BD6"), Color(hex: "#ECE9F7")]),
                            center: .center
                        ),
                        style: StrokeStyle(lineWidth: 18, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.smooth, value: animatedProgress)

                VStack(spacing: 4) {
                    Text("\(Int(viewModel.currentIntakeMl)) / \(Int(viewModel.dailyGoalMl)) ml")
                        .appHeadingStyle()
                    Text("\(Int(animatedProgress * 100))%")
                        .font(.system(.title2, design: .rounded).weight(.semibold))
                        .monospacedDigit()
                }
            }
            .frame(width: 220, height: 220)

            HStack(spacing: AppTheme.Spacing.l) {
                statPill(title: "Goal", value: "\(Int(viewModel.dailyGoalMl)) ml", color: .teal)
                statPill(title: "Today", value: "\(Int(viewModel.currentIntakeMl)) ml", color: .blue)
            }
        }
        .frame(maxWidth: .infinity)
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

    private var actions: some View {
        HStack(spacing: AppTheme.Spacing.m) {
            Button {
                withAnimation(.easeInOut(duration: 0.4)) {
                    viewModel.addWater()
                }
            } label: {
                Label("Add 250 ml", systemImage: "plus.circle.fill")
                    .font(AppTypography.body.weight(.semibold))
                    .appPrimaryButtonStyle()
            }

            Button {
                Task {
                    await viewModel.refreshFromHealthKit()
                }
            } label: {
                Label("Refresh", systemImage: "arrow.clockwise")
                    .font(AppTypography.body)
                    .foregroundStyle(AppColors.accent)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                            .stroke(AppColors.accent, lineWidth: 1)
                    )
            }
        }
    }

    private var stepsCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
            HStack {
                Image(systemName: "figure.walk.motion")
                    .foregroundStyle(AppColors.accent)
                Text("Steps Today")
                    .appHeadingStyle()
                Spacer()
                Text("\(viewModel.stepsToday)")
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .monospacedDigit()
            }
            .padding(.bottom, 4)

            ProgressView(value: min(Double(viewModel.stepsToday) / 10_000.0, 1.0))
                .tint(AppColors.accent)
                .animation(.smooth, value: viewModel.stepsToday)

            Text("Goal: 10,000 steps")
                .appCaptionStyle()
        }
        .padding(AppTheme.Spacing.l)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .fill(AppColors.primaryBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .stroke(AppColors.borderSubtle, lineWidth: 1)
        )
    }

    private func statPill(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .appCaptionStyle()
            Text(value)
                .font(.system(.subheadline, design: .rounded).weight(.semibold))
                .foregroundStyle(AppColors.textPrimary)
        }
        .padding(.vertical, AppTheme.Spacing.s)
        .padding(.horizontal, AppTheme.Spacing.m)
        .background(
            Capsule(style: .continuous)
                .fill(AppColors.primaryBackground)
        )
    }
}

#Preview {
    DashboardView()
}
