//
//  ContentView.swift
//  DayTrip
//
//  Created by Stef Kors on 07/08/2024.
//

import SwiftUI
import SwiftData
import MapKit

@MainActor
class DataController {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Route.self, configurations: config)

            container.mainContext.insert(Route.preview)
            container.mainContext.insert(Route.preview2)
            container.mainContext.insert(Route.preview3)
            print("Preview container created with routes.")
            return container
        } catch {
            print("failed")
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}


struct ContentView: View {
    @StateObject var manager = LocationManager()

    var body: some View {
        FoldingView()
            .environmentObject(manager)
    }
}

#Preview {
    ContentView()
        .modelContainer(DataController.previewContainer)
        .environmentObject(LocationManager())
}
