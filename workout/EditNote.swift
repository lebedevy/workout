//
//  EditNote.swift
//  workout
//
//  Created by Yury Lebedev on 3/5/25.
//

import SwiftUI

struct EditNote: View {
    @Environment(\.managedObjectContext) private var store
    
    init(exercise: Exercise, open: Binding<Bool>) {
        self.exercise = exercise
        self._open = open
        
        self.text = exercise.notes ?? ""
    }
    
    @ObservedObject var exercise: Exercise
    @Binding var open: Bool
    @State private var text: String
    
    var body: some View {
        VStack {
            TextField("Exercise notes", text: $text)
                .frame(maxHeight: .infinity)
                .padding()
                .border(.secondary)
                .multilineTextAlignment(.center)
            HStack {
                Button("Cancel", action: cancel)
                Spacer()
                Button("Save", action: save)
                    .buttonStyle(.borderedProminent)
            }
        }
        .padding()
    }
    
    private func cancel() {
        open.toggle()
    }
    
    private func save() {
        exercise.notes = text
        
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
}


#Preview {
    struct Preview: View {
        @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.created_at, ascending: true)],
            animation: .default)
        private var exercises: FetchedResults<Exercise>
        @State private var open = true
        
        var body: some View {
            // This preview will crash when there are zero exercises
            EditNote(exercise: exercises.first!, open: $open)
        }
    }
    
    return Preview().environment(\.managedObjectContext, Store.preview.persistanceContainer.viewContext)
}
