//
//  VocabularyApp.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 18.08.24.
//

import SwiftUI

@main
struct VocabularyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [VocabularySet.self, Vocabulary.self, Language.self], inMemory: false)
        }
    }
}
