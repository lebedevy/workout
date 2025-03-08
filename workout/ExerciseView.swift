//
//  ExerciseView.swift
//  workout
//
//  Created by Yury Lebedev on 3/5/25.
//

import SwiftUI

struct ExerciseView: View {
    @ObservedObject var exercise: Exercise
    
    var sets: [Set] {
        exercise.exercise_to_set?.array as? [Set] ?? []
    }
    
    var body: some View {
        VStack {
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
            // TODO: Make this collapsable
            if let notes = exercise.notes {
                Text(notes)
            }
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
