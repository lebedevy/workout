//
//  AddExercise.swift
//  workout
//
//  Created by Yury Lebedev on 2/12/25.
//

import Foundation
import SwiftUI

struct AddExercise: View {
    @Environment(\.managedObjectContext) private var store
    
    let workout: Workout
    @Binding var open: Bool
    @State private var search = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseType.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<ExerciseType>
    
    var body: some View {
        NavigationStack {
            VStack {
                TextField("Search or add exercise", text: $search)
                    .textFieldStyle(.roundedBorder)
                    .padding()
                Section {
                    List {
                        ForEach(filterExercises(exercises: Array(items), searchText: search)) { item in
                            Text(item.name ?? "Exercise")
                                .onTapGesture {
                                    addExercise(exerciseType: item)
                                }
                        }
                        if search.isEmpty {
                            HStack {
                                Image(systemName: "plus")
                                Text("Start typing to add a new exercise")
                            }.foregroundColor(.gray)
                        } else {
                            Button(search, systemImage: "plus") {
                                createExercise(name: search)
                            }
                        }
                    }
                }
                Button("Cancel", action: cancel)
            }
        }
    }
    
    func cancel() {
        open.toggle()
    }
    
    func createExercise(name: String) {
        let exerciseType = ExerciseType(context: store)
        exerciseType.name = name
        
        generateExerciseObj(exerciseType: exerciseType)
        
        do {
            try store.save()
            open.toggle()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func addExercise(exerciseType: ExerciseType) {
        generateExerciseObj(exerciseType: exerciseType)
        
        do {
            try store.save()
            open.toggle()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func generateExerciseObj(exerciseType: ExerciseType) {
        let exercise = Exercise(context: store)
        exercise.created_at = Date()
        exercise.exercise_to_type = exerciseType
        exercise.exercise_to_workout = workout
    }
    
    func filterExercises(
        exercises: [ExerciseType],
        searchText: String
    ) -> [ExerciseType] {
        guard !searchText.isEmpty else { return exercises }
        return exercises.filter { exercise in
            // TODO: fix the !
            exercise.name!.lowercased().contains(searchText.lowercased())
        }
    }
}

#Preview {
    struct Preview: View {
        @State var isOpen = true
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Workout.created_at, ascending: true)],
            animation: .default)
        private var workouts: FetchedResults<Workout>
        var body: some View {
            AddExercise(workout: workouts.first!, open: $isOpen)
        }
    }

    return Preview().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}

