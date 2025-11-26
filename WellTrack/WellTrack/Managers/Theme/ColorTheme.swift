import SwiftUI

/// Global color system for the WellTrack app, Lavender Theme B (60–30–10).
enum AppColors {

    // MARK: - Brand Palette (60–30–10)

    /// 60% – Primary background (White in light mode)
    static var primaryBackground: Color {
        Color(light: Color.white,
              dark: Color(hex: "#060713"))
    }

    /// 30% – Secondary surface (light neutral gray for cards/entries)
    static var secondarySurface: Color {
        Color(light: Color(hex: "#F3F4F6"),
              dark: Color(hex: "#1F2937"))
    }

    /// 10% – Accent (Royal purple for primary buttons)
    static var accent: Color {
        // Light: royal purple #7851A9, Dark: deeper royal purple #5A3C82
        Color(light: Color(hex: "#7851A9"),
              dark: Color(hex: "#5A3C82"))
    }

    // MARK: - Text

    static var textPrimary: Color {
        Color(light: Color.black,
              dark: Color.white)
    }

    static var textSecondary: Color {
        Color(light: Color(hex: "#6B7280"),
              dark: Color(hex: "#9CA3AF"))
    }

    // MARK: - Borders & Shadows

    static var borderSubtle: Color {
        Color(light: Color.black.opacity(0.06),
              dark: Color.white.opacity(0.08))
    }

    static var shadow: Color {
        Color(light: Color.black.opacity(0.12),
              dark: Color.black.opacity(0.45))
    }
}

// MARK: - Light/Dark Convenience Initializer

extension Color {

    /// Convenience initializer for pairing light and dark variants.
    init(light: Color, dark: Color) {
        self = Color(UIColor { traitCollection in
            traitCollection.userInterfaceStyle == .dark
            ? UIColor(dark)
            : UIColor(light)
        })
    }
}
