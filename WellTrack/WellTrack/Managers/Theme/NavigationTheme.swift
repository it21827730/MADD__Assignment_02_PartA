import SwiftUI

/// Modifier to style navigation bars with Lavender Theme B.
struct NavigationBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(AppColors.secondarySurface, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
    }
}

extension View {
    func appNavigationBarStyle() -> some View {
        self.modifier(NavigationBarModifier())
    }
}

/// Example usage preview.
struct NavigationTheme_Preview: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: AppTheme.Spacing.l) {
                Text("Navigation Themed Screen")
                    .appTitleMediumStyle()
                Text("This uses the Lavender secondary surface for the nav bar background.")
                    .appBodyStyle()
            }
            .padding(AppTheme.Spacing.l)
            .navigationTitle("WellTrack")
            .appNavigationBarStyle()
            .appScreenBackground()
        }
    }
}

#Preview {
    NavigationTheme_Preview()
}
