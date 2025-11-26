import Foundation
import CoreData

/// CoreDataManager handles the Core Data stack and provides methods to manage HydrationEntry entities.
final class CoreDataManager {
    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WellTrackModel")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    private init() {}

    /// Saves the context if there are changes.
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved Core Data save error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    /// Adds a new hydration entry with the specified amount and date.
    func addEntry(amount: Double, date: Date = Date()) {
        let entry = HydrationEntry(context: viewContext)
        entry.id = UUID()
        entry.amount = amount
        entry.date = date
        saveContext()
    }

    /// Fetches all hydration entries, optionally filtered by date range.
    func fetchEntries(from startDate: Date? = nil, to endDate: Date? = nil) -> [HydrationEntry] {
        let request: NSFetchRequest<HydrationEntry> = HydrationEntry.fetchRequest()
        if let start = startDate, let end = endDate {
            request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", start as NSDate, end as NSDate)
        }
        request.sortDescriptors = [NSSortDescriptor(keyPath: \HydrationEntry.date, ascending: false)]
        do {
            return try viewContext.fetch(request)
        } catch {
            print("Fetch error: \(error)")
            return []
        }
        }

    /// Deletes a specific hydration entry.
    func deleteEntry(_ entry: HydrationEntry) {
        viewContext.delete(entry)
        saveContext()
    }
}

