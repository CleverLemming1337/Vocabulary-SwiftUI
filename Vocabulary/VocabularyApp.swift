//
//  VocabularyApp.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 18.08.24.
//

import SwiftUI
import SwiftData

let MODELS: [any PersistentModel.Type] = [VocabularySet.self, Vocabulary.self, Language.self]

@main
struct VocabularyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: MODELS, inMemory: false)
        }
    }
}
