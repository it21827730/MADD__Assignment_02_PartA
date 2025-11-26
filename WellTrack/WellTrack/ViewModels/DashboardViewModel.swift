import Foundation
import Combine

/// DashboardViewModel manages hydration progress and reads today's fitness data via HealthKitManager.
final class DashboardViewModel: ObservableObject {
    // MARK: - Hydration State
    @Published var dailyGoalMl: Double = 2000
    @Published var currentIntakeMl: Double = 750

    // MARK: - Health Data (Published for UI)
    @Published var stepsToday: Int = 0
    @Published var activeEnergyKCal: Double = 0

    // MARK: - Dependencies
    private let healthKit: HealthKitManager
    private let hydrationGoalKey = "daily_hydration_goal_ml"

    init(healthKit: HealthKitManager = .shared) {
        self.healthKit = healthKit
        let savedGoal = UserDefaults.standard.double(forKey: hydrationGoalKey)
        if savedGoal > 0 {
            dailyGoalMl = savedGoal
        }
    }

    /// Hydration progress between 0 and 1.
    var progress: Double {
        let ratio = currentIntakeMl / max(dailyGoalMl, 1)
        return min(max(ratio, 0), 1)
    }

    /// Increments the current intake, clamped to the daily goal.
    func addWater(amountMl: Double = 250) {
        let newAmount = min(currentIntakeMl + amountMl, dailyGoalMl)
        currentIntakeMl = newAmount
    }

    // MARK: - HealthKit

    /// Requests HealthKit authorization then fetches today's steps and active energy using async/await.
    @MainActor
    func setupHealthKit() async {
        do {
            let granted = try await healthKit.requestAuthorization()
            if granted {
                await refreshFromHealthKit()
            } else {
                // Fallback: provide mock values so UI still shows data.
                stepsToday = 5000 + Int.random(in: 0...3000)
                activeEnergyKCal = 300 + Double(Int.random(in: 0...200))
            }
        } catch {
            // On error, use mock data
            stepsToday = 5000 + Int.random(in: 0...3000)
            activeEnergyKCal = 300 + Double(Int.random(in: 0...200))
        }
    }

    /// Fetches today's steps and active energy from HealthKit using async/await.
    @MainActor
    func refreshFromHealthKit() async {
        stepsToday = Int((await healthKit.fetchTodayStepCount()).rounded())
        activeEnergyKCal = await healthKit.fetchTodayActiveEnergy()
    }

    /// Legacy/mock data refresher kept for testing without HealthKit.
    func refreshMockData() {
        stepsToday = 5000 + Int.random(in: 0...3000)
        activeEnergyKCal = 300 + Double(Int.random(in: 0...200))
    }
}
