//
//  VocabularySetList.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularySetList: View {
    @Query var vocabularySets: [VocabularySet]
    @Environment(\.modelContext) var modelContext
    @State private var addSet = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(vocabularySets) { set in
                    NavigationLink(destination: VocabularySetView(set: set)) {
                        Text(set.name)
                    }
                }
                Button("Add", systemImage: "plus") {
                    addSet = true
                }
            }
            .sheet(isPresented: $addSet) {
                AddSetView()
                
                    .presentationBackgroundInteraction(.automatic)
                    .presentationDetents([.large, .medium])
                    .presentationBackgroundInteraction(.automatic)
                    .navigationTitle("Create new set")
            }
            .navigationTitle("Vocabulary sets")
        }
    }
}
