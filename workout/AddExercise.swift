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
    
    @Binding var open: Bool
    @State private var search = ""
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseType.name, ascending: true)],
        animation: .default)
    private var items: FetchedResults<ExerciseType>
    
    var body: some View {
        NavigationStack {
            VStack {
                List(filterExercises(exercises: Array(items), searchText: search)) { item in
                    Text(item.name ?? "Exercise")
                        .onTapGesture {
                            addExercise(exerciseType: item)
                        }
                }
                Button("Cancel", action: cancel)
            }
        }.searchable(text: $search, prompt: "Search or add exercise")
    }
    
    func cancel() {
        open.toggle()
    }
    
    func addExercise(exerciseType: ExerciseType) {
        let exercise = Exercise(context: store)
        exercise.created_at = Date()
        exercise.exercise_to_type = exerciseType
        
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
        var body: some View {
            AddExercise(open: $isOpen)
        }
    }

    return Preview().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}

