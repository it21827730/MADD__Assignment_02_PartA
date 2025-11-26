//
//  WellTrackApp.swift
//  WellTrack
//
//  Created by STUDENT on 2025-11-18.
//

import SwiftUI
import CoreData

@main
struct WellTrackApp: App {
    private let coreData = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreData.viewContext)
        }
    }
}
