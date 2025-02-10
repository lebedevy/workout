//
//  Main.swift
//  workout
//
//  Created by Yury Lebedev on 1/19/25.
//

import Foundation
import SwiftUI

// Workout - a collection of sessions
// Exercise - a collection of sets
// Set - a collection of reps
// Rep - a single repetition of an excercise

struct Main: View {
    @Environment(\.managedObjectContext) private var store
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Exercise>
    
    var body: some View {
        VStack {
            Text("Workout")
                .font(.largeTitle)
                .padding()
            ScrollView {
                ForEach(items) { item in
                    ExerciseView(exercise: item)
                }
            }
            SetInput()
        }
    }
}

struct ExerciseView: View {
    let exercise: Exercise
    
    var body: some View {
        HStack {
            VStack {
                Text("Weight").padding([.bottom], 0)
                Text("Reps").padding()
            }.frame(alignment: .leading)
            ScrollView([.horizontal]) {
                HStack {
                    SetView(weight: 120, reps: 12)
                    SetView(weight: 135, reps: 10)
                    SetView(weight: 135, reps: 10)
                    SetView(weight: 135, reps: 10)
                    SetView(weight: 145, reps: 10)
                    SetView(weight: 135, reps: 10)
                }
            }.defaultScrollAnchor(.trailing)
        }.padding()
    }
}

struct SetView: View {
    let weight: Int
    let reps: Int
    
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
