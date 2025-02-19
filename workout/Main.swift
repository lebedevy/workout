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
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Workout.created_at, ascending: true)],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    
    var body: some View {
        NavigationStack() {
            List {
                ForEach(Array(workouts)) { workout in
                    Section(header: Text(workout.name ?? "Workout")) {
                        WorkoutSection(workout: workout)
                    }
                }
            }
            .navigationDestination(for: Exercise.self) { exercise in ExercisePage(selected: exercise.objectID)
            }
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
