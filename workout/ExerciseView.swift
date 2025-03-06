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
