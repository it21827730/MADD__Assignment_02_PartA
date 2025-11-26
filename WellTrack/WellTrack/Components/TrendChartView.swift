import SwiftUI
import Charts

struct TrendPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double
}

struct TrendChartView: View {
    let title: String
    let points: [TrendPoint]
    @State private var opacity: Double = 0

    var body: some View {
        VStack(alignment: .leading, spacing: AppTheme.Spacing.m) {
            Text(title)
                .appHeadingStyle()

            Chart(points) { point in
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(GradientTheme.mintAccentGradient)
                AreaMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .foregroundStyle(GradientTheme.mintAccentGradient.opacity(0.3))
            }
            .frame(height: 160)
            .opacity(opacity)
            .animation(.easeIn(duration: 0.6), value: opacity)
        }
        .appCardContainer()
        .onAppear {
            opacity = 1.0
        }
    }
}

#Preview {
    let calendar = Calendar.current
    let today = Date()
    let points = (0..<7).compactMap { i -> TrendPoint in
        let date = calendar.date(byAdding: .day, value: -i, to: today) ?? today
        return TrendPoint(date: date, value: Double.random(in: 800...2400))
    }.sorted { $0.date < $1.date }

    return TrendChartView(title: "Hydration Trend", points: points)
        .padding(AppTheme.Spacing.l)
        .appScreenBackground()
}
