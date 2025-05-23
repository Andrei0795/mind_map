//
//  MindMap_SwiftUIApp.swift
//  MindMap SwiftUI
//
//  Created by Andrei Ionescu on 03.04.2025.
//

import SwiftUI
import SwiftData

@main
struct MindMap_SwiftUIApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MindNode.self,
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
            MindMapView()
        }
        .modelContainer(sharedModelContainer)
    }
}

