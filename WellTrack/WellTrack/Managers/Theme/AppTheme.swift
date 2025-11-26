import SwiftUI

/// Global spacing, corner radii, elevations, and reusable styles for WellTrack.
enum AppTheme {

    // MARK: - Spacing Scale

    enum Spacing {
        static let xs: CGFloat = 4
        static let s:  CGFloat = 8
        static let m:  CGFloat = 12
        static let l:  CGFloat = 16
        static let xl: CGFloat = 24
        static let xxl: CGFloat = 32
    }

    // MARK: - Corner Radius

    enum CornerRadius {
        static let small: CGFloat = 8
        static let medium: CGFloat = 16
        static let large: CGFloat = 24
        static let pill: CGFloat = 999
    }

    // MARK: - Elevation (Shadow)

    enum Elevation {
        static let card: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            AppColors.shadow, 8, 0, 4
        )
        static let floating: (color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) = (
            AppColors.shadow, 16, 0, 8
        )
    }
}

// MARK: - Button & Card Styles

extension View {

    /// Primary call-to-action button style (accent filled).
    func appPrimaryButtonStyle() -> some View {
        self
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity)
            .background(AppColors.accent)
            .foregroundStyle(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: AppTheme.CornerRadius.medium, style: .continuous))
            .shadow(color: AppTheme.Elevation.card.color,
                    radius: AppTheme.Elevation.card.radius,
                    x: AppTheme.Elevation.card.x,
                    y: AppTheme.Elevation.card.y)
    }

    /// Secondary surface card style.
    func appCardStyle() -> some View {
        self
            .padding(AppTheme.Spacing.l)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: AppTheme.CornerRadius.large, style: .continuous)
                    .fill(AppColors.secondarySurface)
            )
            .shadow(color: AppTheme.Elevation.card.color,
                    radius: AppTheme.Elevation.card.radius,
                    x: AppTheme.Elevation.card.x,
                    y: AppTheme.Elevation.card.y)
    }

    /// Background for root screens.
    func appScreenBackground() -> some View {
        self
            .background(AppColors.primaryBackground.ignoresSafeArea())
    }
}
