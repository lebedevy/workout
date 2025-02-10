//
//  workoutApp.swift
//  workout
//
//  Created by Yury Lebedev on 1/19/25.
//

import SwiftUI

@main
struct workoutApp: App {
    let persistenceController = Store.shared

    var body: some Scene {
        WindowGroup {
            Main()
                .environment(\.managedObjectContext, persistenceController.persistanceContainer.viewContext)
        }
    }
}
