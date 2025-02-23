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
    @Environment(\.managedObjectContext) private var store
    
    @FetchRequest(entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: false)],
        predicate: NSPredicate(value: false), animation: .default)
    private var exercises: FetchedResults<Exercise>
    
    let selected: NSManagedObjectID
    
    var items: [Exercise] {
        exercises.filter { $0.objectID != selected }
    }
    
    var exercise: Exercise? {
        exercises.first(where: {i in i.objectID == selected})
    }
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(items) { ex in
                    ExerciseView(exercise: ex)
                        .padding()
                }
            }.defaultScrollAnchor(.bottom)
            if let exercise {
                Divider()
                Text("Current exercise")
                ExerciseView(exercise: exercise)
                    .padding()
            }
            SetInput(add: addSet)
        }
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding()
            .navigationTitle(exercise?.exercise_to_type?.name ?? "Exercise")
            .onChange(of: exercise, initial: true, { _, value in
                let predicate = NSPredicate(format: "exercise_to_type.name == %@", value?.exercise_to_type?.name ?? "")
                
                exercises.nsPredicate = predicate
            })
    }
    
    func addSet(weight: Double, reps: Double) {
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

struct ExerciseView: View {
    @ObservedObject var exercise: Exercise
    
    var sets: [Set] {
        exercise.exercise_to_set?.array as? [Set] ?? []
    }
    
    var body: some View {
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
        @FetchRequest(entity: Exercise.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: true)],
            animation: .default)
        private var exercises: FetchedResults<Exercise>
        
        var body: some View {
            // This preview will crash when there are zero exercises
            ExercisePage(selected: exercises.first!.objectID)
        }
    }
    
    return Preview().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}
