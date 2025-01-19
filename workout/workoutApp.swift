//
//  workoutApp.swift
//  workout
//
//  Created by Yury Lebedev on 1/19/25.
//

import SwiftUI

@main
struct workoutApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
