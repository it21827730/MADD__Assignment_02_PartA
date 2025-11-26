import SwiftUI

/// Reusable card container modifier for consistent padding/corners/shadow.
struct CardContainer: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(AppTheme.Spacing.l)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                    .fill(AppColors.primaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                    .stroke(AppColors.borderSubtle, lineWidth: 1)
            )
            .shadow(color: AppColors.shadow,
                    radius: AppTheme.Elevation.card.radius,
                    x: AppTheme.Elevation.card.x,
                    y: AppTheme.Elevation.card.y)
    }
}

extension View {
    func appCardContainer() -> some View {
        self.modifier(CardContainer())
    }
}

#Preview {
    VStack(alignment: .leading, spacing: AppTheme.Spacing.s) {
        Text("Hydration")
            .appHeadingStyle()
        Text("Track your water intake throughout the day.")
            .appBodyStyle()
    }
    .appCardContainer()
    .padding(AppTheme.Spacing.l)
    .appScreenBackground()
}
