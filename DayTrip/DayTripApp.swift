//
//  DayTripApp.swift
//  DayTrip
//
//  Created by Stef Kors on 07/08/2024.
//

import SwiftUI
import SwiftData

@main
struct DayTripApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Route.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
