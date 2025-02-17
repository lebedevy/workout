//
//  Store.swift
//  workout
//
//  Created by Yury Lebedev on 2/9/25.
//

import Foundation
import CoreData

// Doc ref https://developer.apple.com/documentation/coredata/setting_up_a_core_data_stack
struct Store {
    // Singleton
    static let shared = Store()
    
    let persistanceContainer: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        persistanceContainer = NSPersistentContainer(name: "workout")
        
        if inMemory {
            persistanceContainer.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        
        persistanceContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        // Unclear if I actually want this
        persistanceContainer.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    // Preview; edited from original default Persistance store
    static let preview: Store = {
        let result = Store(inMemory: true)
        let viewContext = result.persistanceContainer.viewContext
        
        addTestData(viewContext: viewContext)
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}

func addTestData(viewContext: NSManagedObjectContext) {
    let arr = ["Bench", "Squat", "Bench", "Curls - supinated"]
    var types: Dictionary<String, ExerciseType> = [:]
    
    for _ in 0..<5 {
        let workout = Workout(context: viewContext)
        workout.created_at = Date()
        
        for _ in 0..<2 {
            // Test data where we know the array is not empty
            let item = arr.randomElement()!
            
            // Add or get exericse type
            let eType: ExerciseType
            if let val = types[item] {
                eType = val
            } else {
                eType = ExerciseType(context: viewContext)
                eType.name = item
                types[item] = eType
            }
            
            // add exercise instance
            let newItem = Exercise(context: viewContext)
            newItem.created_at = Date()
            
            // add sets
            var sets: [Set] = []
            for i in 0..<10 {
                let set = Set(context: viewContext)
                set.reps = Double(i)
                set.weight = Double(i) * 10.0
                sets.append(set)
            }
            
            // Set relationships
            newItem.exercise_to_set = NSOrderedSet(array: sets)
            newItem.exercise_to_type = eType
            newItem.exercise_to_workout = workout
        }
    }
}
