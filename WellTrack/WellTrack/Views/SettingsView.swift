import SwiftUI
import UserNotifications

struct SettingsView: View {
    @AppStorage("reminders_enabled") private var remindersEnabled = false
    @State private var dailyGoal: Double = 2000
    private let hydrationGoalKey = "daily_hydration_goal_ml"
    private let reminderManager = ReminderManager.shared
    @State private var showingPermissionAlert = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Hydration Goal") {
                    Stepper("Daily Goal: \(Int(dailyGoal)) ml", value: $dailyGoal, in: 500...5000, step: 250)
                        .onChange(of: dailyGoal) { _, newValue in
                            UserDefaults.standard.set(newValue, forKey: hydrationGoalKey)
                        }
                }

                Section("Reminders") {
                    Toggle("Enable Reminders", isOn: $remindersEnabled)
                        .onChange(of: remindersEnabled) { _, newValue in
                            if newValue {
                                reminderManager.requestAuthorization { granted in
                                    if granted {
                                        reminderManager.scheduleReminders()
                                    } else {
                                        remindersEnabled = false
                                        showingPermissionAlert = true
                                    }
                                }
                            } else {
                                reminderManager.cancelReminders()
                            }
                        }
                    Text("Get reminded to drink water every 2 hours (8AM - 8PM)")
                        .appCaptionStyle()
                }
            }
            .navigationTitle("Settings")
            .appScreenBackground()
            .onAppear {
                // Load saved hydration goal
                let saved = UserDefaults.standard.double(forKey: hydrationGoalKey)
                if saved > 0 {
                    dailyGoal = saved
                }

                // Sync the toggle with actual system authorization
                reminderManager.getAuthorizationStatus { status in
                    switch status {
                    case .authorized, .provisional, .ephemeral:
                        // Keep the stored preference
                        break
                    case .denied:
                        // If user disabled notifications in system settings, reflect it in UI
                        remindersEnabled = false
                    case .notDetermined:
                        // User hasn't decided yet; keep stored preference off
                        if remindersEnabled {
                            remindersEnabled = false
                        }
                    @unknown default:
                        break
                    }
                }
            }
            .alert("Notifications Disabled", isPresented: $showingPermissionAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Open Settings") {
                    if let url = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(url)
                    }
                }
            } message: {
                Text("To enable reminders, allow notifications in Settings.")
            }
        }
    }
}

#Preview {
    SettingsView()
}

