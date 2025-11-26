import Foundation
import UserNotifications

/// ReminderManager handles local notifications for hydration reminders.
final class ReminderManager {
    static let shared = ReminderManager()
    private let center = UNUserNotificationCenter.current()

    private init() {}

    /// Requests notification authorization from the user.
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }

    /// Returns current authorization status for notifications.
    func getAuthorizationStatus(completion: @escaping (UNAuthorizationStatus) -> Void) {
        center.getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus)
            }
        }
    }

    /// Schedules hydration reminders every 2 hours between 8AM and 8PM.
    func scheduleReminders() {
        center.removeAllPendingNotificationRequests()

        let content = UNMutableNotificationContent()
        content.title = "Hydration Reminder"
        content.body = "Time to drink water 💧"
        content.sound = .default

        var hour = 8
        while hour <= 20 {
            var dateComponents = DateComponents()
            dateComponents.hour = hour
            dateComponents.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "hydration-\(hour)",
                content: content,
                trigger: trigger
            )
            center.add(request)
            hour += 2
        }
    }

    /// Cancels all scheduled hydration reminders.
    func cancelReminders() {
        center.removeAllPendingNotificationRequests()
    }
}

