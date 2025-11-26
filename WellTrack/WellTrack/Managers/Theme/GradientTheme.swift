import SwiftUI

/// Gradients based on Lavender Theme B.
enum GradientTheme {

    /// Lavender gray → wisteria purple.
    static var lavenderGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "#ECE9F7"),
                Color(hex: "#A58BD6")
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    /// Wisteria → mint aqua accent.
    static var mintAccentGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(hex: "#A58BD6"),
                Color(hex: "#4ED2B8")
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}
