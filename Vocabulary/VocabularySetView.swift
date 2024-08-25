//
//  VocabularySetView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct VocabularySetView: View {
    let set: VocabularySet
    @Query var vocabulary: [Vocabulary]
    var body: some View {
        List {
            Section("Pinned words") {
                ComingSoonLabel()
            }
            Section("Weak words") {
                ComingSoonLabel()
            }
            Section("Sections") {
                ForEach(set.sections.sorted(by: { $0.number < $1.number }), id: \.self) { section in
                    NavigationLink(destination: { VocabularySectionView(fromLang: set.from, toLang: set.to, section: section) }) {
                        Text("\(section.number)")
                    }
                }
            }
        }
        .navigationTitle(set.name)
    }
}
