//
//  ExerciseView.swift
//  workout
//
//  Created by Yury Lebedev on 3/5/25.
//

import SwiftUI

struct ExerciseView: View {
    @ObservedObject var exercise: Exercise
    
    var sets: [SetPage] {
        let arr = exercise.exercise_to_set?.array as? [Set] ?? []
        let step = 4
        return stride(from: 0, to: arr.count, by: step).map {
            SetPage(sets: Array(arr[$0..<min($0 + step, arr.count)]))
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                VStack {
                    Text("Weight").padding([.bottom], 0)
                    Text("Reps").padding()
                }.frame(alignment: .leading)
                TabView {
                    ForEach(sets) { page in
                        HStack {
                            ForEach(page.sets) { item in
                                SetView(info: item)
                            }
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: sets.count > 1 ? .always : .never))
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

struct SetPage: Identifiable {
    let id = UUID()
    let sets: [Set]
    
    init(sets: [Set]) {
        self.sets = sets
    }
}
