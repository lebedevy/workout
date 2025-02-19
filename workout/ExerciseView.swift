//
//  ExerciseView.swift
//  workout
//
//  Created by Yury Lebedev on 2/18/25.
//

import Foundation
import CoreData
import SwiftUI

struct ExerciseView: View {
    @ObservedObject var exercise: Exercise
    
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
    struct Preview: View {        
        @FetchRequest(
            sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: true)],
            animation: .default)
        private var exercises: FetchedResults<Exercise>
        
        var body: some View {
            ExerciseView(exercise: exercises.first!)
        }
    }
    
    return Preview().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}
