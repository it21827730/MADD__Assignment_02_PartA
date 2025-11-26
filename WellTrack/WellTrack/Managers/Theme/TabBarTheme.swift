import SwiftUI

/// Helper view to wrap a TabView with consistent accent colors.
struct AppTabContainer<Content: View>: View {
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .tint(AppColors.textSecondary)
    }
}

struct TabBarTheme_Preview: View {
    var body: some View {
        AppTabContainer {
            TabView {
                Text("Home")
                    .tabItem { Label("Home", systemImage: "house.fill") }

                Text("Hydration")
                    .tabItem { Label("Hydration", systemImage: "drop.fill") }
            }
        }
        .appScreenBackground()
    }
}

#Preview {
    TabBarTheme_Preview()
}
