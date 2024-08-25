//
//  VocabularySectionView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularySectionView: View {
    let fromLang: Language
    let toLang: Language
    let section: VocabularySection
    @Query var vocabularies: [Vocabulary]
    @Environment(\.modelContext) var modelContext
    
    @State private var addVocabularySheet = false
    var body: some View {
        List {
            Button("Add", systemImage: "plus") {
                addVocabularySheet = true
            }
            ForEach(vocabularies.filter { $0.sectionId == section.id }) { voc in
                VStack(alignment: .leading) {
                    Text(voc.to)
                    Text(voc.from)
                        .font(.caption)
                        .foregroundStyle(.gray)
                }
            }
            .onDelete(perform: { indexSet in
                for i in indexSet {
                    modelContext.delete(vocabularies[i])
                }
            })
        }
        .toolbar {
            #if os(iOS)
            ToolbarItem(placement: .topBarTrailing) {
                EditButton()
                    .buttonStyle(.borderless)
            }
            #endif
        }
        .navigationTitle("Section \(section.number)")
        .sheet(isPresented: $addVocabularySheet) {
            AddVocabularySheet(sectionId: section.id, fromLang: fromLang, toLang: toLang)
        }
    }
}

