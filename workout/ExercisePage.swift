//
//  ExerciseView.swift
//  workout
//
//  Created by Yury Lebedev on 2/18/25.
//

import Foundation
import CoreData
import SwiftUI

struct ExercisePage: View {
    @ObservedObject var exercise: Exercise
    
    // "Fetch request templates allow you to predefine queries with variables to substitute at runtime"
    // Maybe fetch requests are the answer
    // https://developer.apple.com/documentation/CoreData/NSFetchRequest
    init(exercise: Exercise) {
        self.exercise = exercise
        _exercises = FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: false)], predicate: ExercisePage.getPredicate(exercise: exercise), animation: .default)
    }
    
    @FetchRequest
    private var exercises: FetchedResults<Exercise>
    
    var items: [Exercise] {
        exercises.filter { $0.objectID != exercise.objectID }
    }
    
    var formatter: DateFormatter {
        getFormatter()
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(items) { ex in
                    VStack {
                        if let date = ex.created_at {
                            Text(formatter.string(from: date))
                        }
                        ExerciseView(exercise: ex)
                            .padding()
                    }
                }
            }.defaultScrollAnchor(.bottom)
            CurrentExercise(exercise: exercise)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding()
            .navigationTitle(exercise.exercise_to_type?.name ?? "Exercise")
            .onChange(of: exercise, initial: true, { _, value in                
                exercises.nsPredicate = ExercisePage.getPredicate(exercise: value)
            })
    }
    
    private static func getPredicate(exercise: Exercise) -> NSPredicate {
        return NSPredicate(format: "exercise_to_type.name == %@", exercise.exercise_to_type?.name ?? "")
    }
}

struct CurrentExercise: View {
    @Environment(\.managedObjectContext) private var store
    @ObservedObject var exercise: Exercise
    @State private var isAddingNote = false
    
    var body: some View {
        Divider()
        ZStack(alignment: .trailing) {
            Text("Current exercise")
                .frame(maxWidth: .infinity)
            Menu(content: {
                Button(action: {}, label: {
                    Label("Add tag", systemImage: "tag")
                })
                Button(action: {isAddingNote.toggle()}, label: {
                    Label("Add notes", systemImage: "note")
                })
            }, label: {
                Image(systemName: "ellipsis")
            })
        }
        ExerciseView(exercise: exercise)
            .padding()
        SetInput(add: addSet)
            .sheet(isPresented: $isAddingNote, content: {
                EditNote(exercise: exercise, open: $isAddingNote)
            })
    }
    
    private func addSet(weight: Double, reps: Double) {
        let newSet = Set(context: store)
        newSet.created_at = Date()
        newSet.weight = weight
        newSet.reps = reps
        newSet.set_to_exercise = exercise
        
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

struct SetInput: View {
    let add: (Double, Double) -> Void
    @State var weight = ""
    @State var reps = ""
    
    var body: some View {
        HStack {
            Input(prompt: "Weight", value: $weight)
            Input(prompt: "Reps", value: $reps)
            Button("Add") {
                add(Double(weight) ?? 0, Double(reps) ?? 0)
                weight = ""
                reps = ""
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
    struct Preview: View {
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: true)],
            animation: .default)
        private var exercises: FetchedResults<Exercise>
        
        var body: some View {
            // This preview will crash when there are zero exercises
            ExercisePage(exercise: exercises.first!)
        }
    }
    
    return Preview().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}
