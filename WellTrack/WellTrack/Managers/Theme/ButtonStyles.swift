import SwiftUI

/// Reusable button styles for WellTrack using Lavender Theme B.
struct PrimaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body.weight(.semibold))
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(AppColors.accent.opacity(configuration.isPressed ? 0.8 : 1.0))
            .foregroundStyle(Color.white.opacity(configuration.isPressed ? 0.9 : 1.0))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous))
            .shadow(color: AppColors.shadow,
                    radius: AppTheme.Elevation.card.radius,
                    x: AppTheme.Elevation.card.x,
                    y: AppTheme.Elevation.card.y)
            .opacity(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

/// Secondary outlined button style.
struct SecondaryButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                    .stroke(AppColors.accent.opacity(isEnabled ? 1.0 : 0.4), lineWidth: 1)
            )
            .foregroundStyle(AppColors.accent.opacity(isEnabled ? 1.0 : 0.6))
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .opacity(configuration.isPressed ? 0.9 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

/// Ghost button style for subtle actions.
struct GhostButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(AppTypography.body)
            .padding(.vertical, 8)
            .padding(.horizontal, AppTheme.Spacing.m)
            .foregroundStyle(AppColors.textSecondary.opacity(isEnabled ? 1.0 : 0.4))
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous)
                    .fill(AppColors.primaryBackground.opacity(configuration.isPressed ? 0.8 : 0.6))
            )
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

#Preview("ButtonStyles") {
    VStack(spacing: AppTheme.Spacing.m) {
        Button("Save Mood") {}
            .buttonStyle(PrimaryButtonStyle())

        Button("Refresh Insights") {}
            .buttonStyle(SecondaryButtonStyle())

        Button("Skip for now") {}
            .buttonStyle(GhostButtonStyle())
    }
    .padding(AppTheme.Spacing.l)
    .appScreenBackground()
}
