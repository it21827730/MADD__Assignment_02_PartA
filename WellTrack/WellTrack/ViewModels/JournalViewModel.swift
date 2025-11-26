import Foundation
import Combine

struct JournalEntry: Identifiable {
    let id = UUID()
    let date: Date
    let title: String
    let body: String
}

final class JournalViewModel: ObservableObject {
    @Published var entries: [JournalEntry] = []

    func addEntry(title: String, body: String, date: Date = Date()) {
        let entry = JournalEntry(date: date, title: title, body: body)
        entries.insert(entry, at: 0)
    }
}
