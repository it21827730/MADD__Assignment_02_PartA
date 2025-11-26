import SwiftUI

/// WellTrack typography system (Lavender Theme B).
enum AppTypography {

    /// Largest title, e.g. dashboard header.
    static var titleLarge: Font {
        .system(size: 32, weight: .bold, design: .rounded)
    }

    /// Medium title, e.g. card titles.
    static var titleMedium: Font {
        .system(size: 24, weight: .semibold, design: .rounded)
    }

    /// Section headings.
    static var heading: Font {
        .system(size: 18, weight: .semibold, design: .rounded)
    }

    /// Body text.
    static var body: Font {
        .system(size: 16, weight: .regular, design: .rounded)
    }

    /// Small caption text.
    static var caption: Font {
        .system(size: 12, weight: .regular, design: .rounded)
    }
}

// MARK: - Semantic View Helpers

extension View {

    func appTitleLargeStyle() -> some View {
        self
            .font(AppTypography.titleLarge)
            .foregroundStyle(AppColors.textPrimary)
    }

    func appTitleMediumStyle() -> some View {
        self
            .font(AppTypography.titleMedium)
            .foregroundStyle(AppColors.textPrimary)
    }

    func appHeadingStyle() -> some View {
        self
            .font(AppTypography.heading)
            .foregroundStyle(AppColors.textPrimary)
    }

    func appBodyStyle() -> some View {
        self
            .font(AppTypography.body)
            .foregroundStyle(AppColors.textPrimary)
    }

    func appCaptionStyle() -> some View {
        self
            .font(AppTypography.caption)
            .foregroundStyle(AppColors.textSecondary)
    }
}
