//
//  ExerciseView.swift
//  workout
//
//  Created by Yury Lebedev on 3/5/25.
//

import SwiftUI

struct ExerciseView: View {
    @ObservedObject var exercise: Exercise
    
    var body: some View {
        VStack {
            ExerciseSets(exercise: exercise)
            // TODO: Make this collapsable
            if let notes = exercise.notes {
                Text(notes)
            }
        }
    }
}

struct ExerciseSets: View {
    @ObservedObject var exercise: Exercise
    
    var sets: [Set] {
        exercise.sets?.array as? [Set] ?? []
    }
    
    var body: some View {
        HStack {
            Text("Weight")
            Spacer()
            Text("Reps")
        }.bold()
        ForEach(sets) { item in
            HStack {
                Text(String(item.weight))
                Spacer()
                Text(String(item.reps))
            }
            .swipeActions(allowsFullSwipe: false) {
                Button("Delete", action: {})
            }.tint(.red)
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

#Preview {
    struct Preview: View {
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: true)],
            animation: .default)
        private var exercises: FetchedResults<Exercise>
        
        var body: some View {
            // This preview will crash when there are zero exercises
            ExerciseView(exercise: exercises.first!)
        }
    }
    
    return Preview().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}

struct SetPage: Identifiable {
    let id = UUID()
    let sets: [Set]
    
    init(sets: [Set]) {
        self.sets = sets
    }
}
