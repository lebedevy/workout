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
        sortDescriptors: [ NSSortDescriptor(keyPath: \Workout.created_at, ascending: true)],
        animation: .default)
    private var workouts: FetchedResults<Workout>
    
    var body: some View {
        VStack {
            Text("Workout")
                .font(.largeTitle)
                .padding()
            NavigationStack() {
                List {
                    ForEach(Array(workouts)) { workout in
                        Section(header: Text(workout.name ?? "Workout")) {
                            WorkoutSection(workout: workout)
                        }
                    }
                }
                .navigationDestination(for: Exercise.self) { exercise in ExerciseView(exercise: exercise)
                }
            }
        }
    }
}

struct WorkoutSection: View {
    @State private var showAddExerice = false
    let workout: Workout
    
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

struct ExerciseView: View {
    let exercise: Exercise
    
    var sets: [Set] {
        exercise.exercise_to_set?.array as? [Set] ?? []
    }
    
    var body: some View {
        VStack {
            Text(exercise.exercise_to_type?.name ?? "Exercise")
            HStack {
                VStack {
                    Text("Weight").padding([.bottom], 0)
                    Text("Reps").padding()
                }.frame(alignment: .leading)
                ScrollView([.horizontal]) {
                    HStack {
                        ForEach(sets) { item in
                            SetView(info: item)
                        }
                    }
                }.defaultScrollAnchor(.trailing)
            }
        }.padding()
    }
}

struct SetView: View {
    let info: Set
    
    var weight: Double { info.weight }
    var reps: Double { info.reps }
    
    var body: some View {
        VStack {
            Text(String(weight))
            Text(String(reps)).padding()
        }
    }
}

struct SetInput: View {
    @State var weight = ""
    @State var reps = ""
    
    var body: some View {
        HStack {
            Input(prompt: "Weight", value: $weight)
            Input(prompt: "Reps", value: $reps)
            Button("Add") {
                
            }.buttonStyle(.borderedProminent)
        }.padding()
    }
}

struct Input : View {
    let prompt: String;
    @Binding var value: String
    
    var body: some View {
        TextField(prompt, text: $value)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
    }
}

#Preview {
    Main().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}
