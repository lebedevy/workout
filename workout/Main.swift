//
//  Card.swift
//  workout
//
//  Created by Yury Lebedev on 1/19/25.
//

import Foundation
import SwiftUI

// Workout - a collection of sessions
// Session - a collection of sets
// Set - a collection of reps
// Rep - a single repetition of an excercise

struct Main: View {
    var body: some View {
        VStack {
            Text("Workout")
                .font(.largeTitle)
                .padding()
            ScrollView {
                Session()
                Session()
            }.frame(height: .infinity)
            SetInput()
        }
    }
}

struct Session: View {
    var body: some View {
        HStack {
            VStack {
                Text("Weight").padding([.bottom], 0)
                Text("Reps").padding()
            }.frame(alignment: .leading)
            ScrollView([.horizontal]) {
                HStack {
                    Set(weight: 120, reps: 12)
                    Set(weight: 135, reps: 10)
                    Set(weight: 135, reps: 10)
                    Set(weight: 135, reps: 10)
                    Set(weight: 145, reps: 10)
                    Set(weight: 135, reps: 10)
                }
            }.defaultScrollAnchor(.trailing)
        }.padding()
    }
}

struct Set: View {
    var weight: Int
    var reps: Int
    
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
    var prompt: String;
    @Binding var value: String
    
    var body: some View {
        TextField(prompt, text: $value)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .padding()
    }
}

#Preview {
    Main()
}
