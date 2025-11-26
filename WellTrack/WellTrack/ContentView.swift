//
//  ContentView.swift
//  WellTrack
//
//  Created by STUDENT on 2025-11-18.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var moodViewModel = MoodViewModel()
    @StateObject private var journalViewModel = JournalViewModel()

    var body: some View {
        TabView {
            NavigationStack {
                HomeView(moodViewModel: moodViewModel, journalViewModel: journalViewModel)
            }
            .tabItem {
                Label("Home", systemImage: "house.fill")
            }

            NavigationStack {
                DashboardView()
            }
            .tabItem {
                Label("Dashboard", systemImage: "speedometer")
            }

            NavigationStack {
                HydrationView()
            }
            .tabItem {
                Label("Hydration", systemImage: "drop.fill")
            }

            NavigationStack {
                InsightsView(moodViewModel: moodViewModel)
            }
            .tabItem {
                Label("Insights", systemImage: "chart.bar.fill")
            }

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape.fill")
            }
        }
    }
}

#Preview {
    ContentView()
}
