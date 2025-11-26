import SwiftUI

struct ExampleComponentsPreview: View {
    var body: some View {
        ScrollView {
            VStack(spacing: AppTheme.Spacing.xl) {
                MoodCardView(
                    viewModel: MoodCardViewModel(
                        date: Date(),
                        emoji: "😀",
                        note: "Great productive day with good hydration.",
                        tags: ["Study", "Friends"]
                    )
                )

                InsightBubbleView(title: "Weekly Score", value: "86")

                TrendChartView(
                    title: "Hydration Trend",
                    points: sampleTrendPoints
                )
            }
            .padding(AppTheme.Spacing.l)
        }
        .navigationTitle("Components")
        .appScreenBackground()
    }

    private var sampleTrendPoints: [TrendPoint] {
        let calendar = Calendar.current
        let today = Date()
        return (0..<7).compactMap { i -> TrendPoint in
            let date = calendar.date(byAdding: .day, value: -i, to: today) ?? today
            return TrendPoint(date: date, value: Double.random(in: 800...2400))
        }.sorted { $0.date < $1.date }
    }
}

#Preview {
    NavigationStack {
        ExampleComponentsPreview()
    }
}
