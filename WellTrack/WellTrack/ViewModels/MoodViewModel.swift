import Foundation
import Combine

final class MoodViewModel: ObservableObject {
    enum Mood: String, CaseIterable, Codable {
        case verySad, sad, neutral, happy, veryHappy

        var emoji: String {
            switch self {
            case .verySad: return "😭"
            case .sad: return "☹️"
            case .neutral: return "😐"
            case .happy: return "🙂"
            case .veryHappy: return "😄"
            }
        }

        var label: String {
            switch self {
            case .verySad: return "Very sad"
            case .sad: return "Sad"
            case .neutral: return "Neutral"
            case .happy: return "Happy"
            case .veryHappy: return "Very happy"
            }
        }
    }

    struct MoodEntry: Identifiable, Codable {
        let id: UUID
        let date: Date
        let mood: Mood
        let note: String
    }

    @Published var entries: [MoodEntry] = []
    @Published var selectedMood: Mood = .neutral

    private let storageKey = "mood_entries"

    init() {
        loadEntries()
    }

    var todayMoodLabel: String {
        guard let latest = entries.sorted(by: { $0.date > $1.date }).first else {
            return "Not logged yet"
        }
        return "\(latest.mood.emoji) \(latest.mood.label)"
    }

    /// Returns a numeric score for a mood, useful for charting (1 = very sad ... 5 = very happy).
    func score(for mood: Mood) -> Int {
        switch mood {
        case .verySad: return 1
        case .sad: return 2
        case .neutral: return 3
        case .happy: return 4
        case .veryHappy: return 5
        }
    }

    func saveMood(note: String, date: Date = Date()) {
        let entry = MoodEntry(id: UUID(), date: date, mood: selectedMood, note: note)
        entries.append(entry)
        saveEntries()
    }

    private func loadEntries() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([MoodEntry].self, from: data)
            entries = decoded
        } catch {
            // If decoding fails, start with an empty list
            entries = []
        }
    }

    private func saveEntries() {
        do {
            let data = try JSONEncoder().encode(entries)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            // If encoding fails, we simply don't update stored entries
        }
    }
}
