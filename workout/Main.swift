//
//  Main.swift
//  workout
//
//  Created by Yury Lebedev on 1/19/25.
//

import Foundation
import SwiftUI

// Workout - a collection of exercises
// Exercise - a collection of sets
// Set - a collection of reps
// Rep - a single repetition of an excercise

struct Main: View {
    @Environment(\.managedObjectContext) private var store

    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Workout.created_at, ascending: true)],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    
    var body: some View {
        NavigationStack() {
            ZStack(alignment: .bottomTrailing) {
                List {
                    ForEach(Array(workouts)) { workout in
                        Section(header: Text(workout.name ?? "Workout")) {
                            WorkoutSection(workout: workout)
                        }
                    }
                }
                .navigationDestination(for: Exercise.self) { exercise in ExercisePage(selected: exercise.objectID)
                }
                Button("workout", systemImage: "plus") {
                    addWorkout()
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
    }
    
    private func addWorkout() {
        let workout = Workout(context: store)
        let formatter = DateFormatter()
        let created = Date()
        formatter.dateStyle = .short
        workout.created_at = created
        workout.name = formatter.string(from: created)
        
        do {
            try store.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct WorkoutSection: View {
    @State private var showAddExerice = false
    @ObservedObject var workout: Workout
    
    var exercises: [Exercise] {
        workout.workout_to_exercise?.array as? [Exercise] ?? []
    }
    
    var body: some View {
        ForEach(exercises) { item in
            NavigationLink(item.exercise_to_type?.name ?? "Exercise", value: item)
        }
        Button("Add exercise", systemImage: "plus", action: addExercise)
            .sheet(isPresented: $showAddExerice, content: {
                AddExercise(workout: workout, open: $showAddExerice)
            })

    }
    
    func addExercise() {
        showAddExerice.toggle()
    }
}

#Preview {
    Main().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}
