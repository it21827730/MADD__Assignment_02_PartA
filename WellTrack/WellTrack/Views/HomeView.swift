import SwiftUI

struct HomeView: View {
    @ObservedObject var moodViewModel: MoodViewModel
    @ObservedObject var journalViewModel: JournalViewModel
    @State private var quote: String = "Loading today's motivation..."

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: AppTheme.Spacing.xl) {
                    header
                    quoteCard
                    quickStats
                    navigationCards
                }
                .padding(AppTheme.Spacing.l)
            }
            .navigationTitle("WellTrack")
            .task {
                quote = await QuoteManager.shared.fetchQuote()
            }
            .appScreenBackground()
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
            Text("Welcome back")
                .appTitleLargeStyle()
            Text("Track your hydration, mood, and reflections in one place.")
                .appCaptionStyle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var quoteCard: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
            Text("Today's Motivation")
                .appCaptionStyle()
            Text(quote)
                .appBodyStyle()
        }
        .padding(AppTheme.Spacing.l)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                .fill(GradientTheme.lavenderGradient)
        )
        .shadow(color: AppColors.shadow,
                radius: AppTheme.Elevation.card.radius,
                x: AppTheme.Elevation.card.x,
                y: AppTheme.Elevation.card.y)
    }

    private var quickStats: some View {
        HStack(spacing: AppTheme.Spacing.l) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Today's Mood")
                    .appCaptionStyle()
                Text(moodViewModel.todayMoodLabel)
                    .appHeadingStyle()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.Spacing.l)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                    .fill(AppColors.secondarySurface)
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Journal Entries")
                    .appCaptionStyle()
                Text("\(journalViewModel.entries.count)")
                    .appHeadingStyle()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(AppTheme.Spacing.l)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                    .fill(AppColors.secondarySurface)
            )
        }
    }

    private var navigationCards: some View {
        VStack(spacing: 16) {
            NavigationLink {
                MoodTrackerView(viewModel: moodViewModel)
            } label: {
                card(icon: "face.smiling", title: "Track Mood", subtitle: "Log how you feel today.", tint: .purple)
            }

            NavigationLink {
                JournalView(viewModel: journalViewModel)
            } label: {
                card(icon: "book.closed.fill", title: "Journal", subtitle: "Write and reflect on your day.", tint: .orange)
            }

            NavigationLink {
                HydrationView()
            } label: {
                card(icon: "drop.fill", title: "Hydration", subtitle: "Track your water intake.", tint: .blue)
            }

            NavigationLink {
                InsightsView(moodViewModel: moodViewModel)
            } label: {
                card(icon: "chart.bar.fill", title: "Insights", subtitle: "View weekly hydration trends.", tint: .teal)
            }
        }
    }

    private func card(icon: String, title: String, subtitle: String, tint: Color) -> some View {
        HStack(spacing: AppTheme.Spacing.l) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(Color.white)
                .frame(width: 44, height: 44)
                .background(tint, in: RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .appHeadingStyle()
                Text(subtitle)
                    .appBodyStyle()
            }

            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(AppColors.textSecondary)
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
}

#Preview {
    HomeView(moodViewModel: MoodViewModel(), journalViewModel: JournalViewModel())
}
