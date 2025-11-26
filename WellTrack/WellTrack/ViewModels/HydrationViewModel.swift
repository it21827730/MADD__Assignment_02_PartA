import Foundation
import Combine
import CoreData

/// HydrationViewModel manages hydration entries using Core Data.
final class HydrationViewModel: ObservableObject {
    @Published var totalTodayMl: Double = 0
    private let coreData: CoreDataManager

    init(coreData: CoreDataManager = .shared) {
        self.coreData = coreData
        updateTotal()
    }

    /// Adds a hydration entry of the specified amount (default 250ml).
    func addWater(amountMl: Double = 250, for date: Date = Date()) {
        coreData.addEntry(amount: amountMl, date: date)
        updateTotal(for: date)
    }

    /// Calculates and updates the total hydration for a specific day.
    func updateTotal(for date: Date = Date()) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? date
        let entries = coreData.fetchEntries(from: startOfDay, to: endOfDay)
        totalTodayMl = entries.reduce(0) { $0 + $1.amount }
    }

    /// Deletes a hydration entry.
    func deleteEntry(_ entry: HydrationEntry) {
        coreData.deleteEntry(entry)
        updateTotal(for: entry.date ?? Date())
    }
}

