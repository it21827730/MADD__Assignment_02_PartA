import SwiftUI

/// Demonstrates Lavender Theme B applied across a sample Home-like screen.
struct ThemeIntegrationExample: View {
    var body: some View {
        AppTabContainer {
            TabView {
                NavigationStack {
                    VStack(spacing: AppTheme.Spacing.xl) {
                        Text("WellTrack")
                            .appTitleLargeStyle()

                        MoodCardView(
                            viewModel: MoodCardViewModel(
                                date: Date(),
                                emoji: "🙂",
                                note: "Feeling balanced and hydrated.",
                                tags: ["Hydration", "Study"]
                            )
                        )

                        Button("Add 250 ml") {}
                            .buttonStyle(PrimaryButtonStyle())
                    }
                    .padding(AppTheme.Spacing.l)
                    .navigationTitle("Home")
                    .appNavigationBarStyle()
                    .appScreenBackground()
                }
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

                NavigationStack {
                    ExampleComponentsPreview()
                }
                .tabItem {
                    Label("Components", systemImage: "square.grid.2x2")
                }
            }
        }
    }
}

#Preview {
    ThemeIntegrationExample()
}
