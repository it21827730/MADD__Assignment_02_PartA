import SwiftUI

struct InsightBubbleView: View {
    let title: String
    let value: String

    @State private var scale: CGFloat = 0.8

    var body: some View {
        VStack(spacing: AppTheme.Spacing.s) {
            Text(title)
                .appCaptionStyle()
            Text(value)
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .foregroundStyle(Color.white)
        }
        .padding(AppTheme.Spacing.l)
        .background(
            Circle()
                .fill(GradientTheme.mintAccentGradient)
        )
        .scaleEffect(scale)
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                scale = 1.0
            }
        }
    }
}

#Preview {
    InsightBubbleView(title: "Weekly Score", value: "82")
        .padding(40)
        .appScreenBackground()
}
