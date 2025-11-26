import Foundation
import HealthKit

/// HealthKitManager encapsulates authorization and simple daily reads for steps and active energy.
/// Replace/extend as needed for additional quantities.
final class HealthKitManager {
    static let shared = HealthKitManager()
    private let healthStore = HKHealthStore()

    private init() {}

    /// Requests read authorization for step count and active energy burned.
    /// - Returns: Success flag and optional error on main actor.
    @MainActor
    func requestAuthorization() async throws -> Bool {
        guard HKHealthStore.isHealthDataAvailable() else {
            throw NSError(domain: "HealthKit", code: 1, userInfo: [NSLocalizedDescriptionKey: "Health data not available on this device."])
        }

        let readTypes: Set<HKObjectType> = [
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!
        ]

        return try await withCheckedThrowingContinuation { continuation in
            healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }

    /// Fetches today's total step count using HKStatisticsQuery.
    /// - Returns: Total step count (Double) on main actor, or 0 on failure.
    @MainActor
    func fetchTodayStepCount() async -> Double {
        guard let stepsType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            return 0
        }
        let (start, end) = Self.todayRange()
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: stepsType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, stats, _ in
                let value = stats?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }

    /// Fetches today's total active energy burned in kilocalories.
    /// - Returns: Total kCal (Double) on main actor, or 0 on failure.
    @MainActor
    func fetchTodayActiveEnergy() async -> Double {
        guard let energyType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            return 0
        }
        let (start, end) = Self.todayRange()
        let predicate = HKQuery.predicateForSamples(withStart: start, end: end, options: .strictStartDate)

        return await withCheckedContinuation { continuation in
            let query = HKStatisticsQuery(quantityType: energyType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, stats, _ in
                let value = stats?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie()) ?? 0
                continuation.resume(returning: value)
            }
            healthStore.execute(query)
        }
    }

    /// Returns the start and end Date of "today" in the current calendar/time zone.
    private static func todayRange() -> (Date, Date) {
        let cal = Calendar.current
        let start = cal.startOfDay(for: Date())
        let end = Date()
        return (start, end)
    }
}
