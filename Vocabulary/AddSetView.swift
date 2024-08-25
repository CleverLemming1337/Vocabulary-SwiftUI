//
//  AddSetView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct AddSetView: View {
    @Environment(\.modelContext) var modelContext
    @Query var languages: [Language]
    @State private var addLang = false
    @State private var selectedLanguage: Language? = nil
    @State private var setName: String = ""
    @State private var comment: String = ""
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        List {
            Section("Name") {
                TextField("Set name", text: $setName)
            }
            Section("Comment") {
                TextField("Comment", text: $comment)
            }
            Section("Language") {
                Button(selectedLanguage?.name ?? "Select language") {
                    addLang = true
                }
                .sheet(isPresented: $addLang) {
                    SelectLanguageView(isPresented: $addLang, selectedLanguage: $selectedLanguage)
                        .navigationTitle("Select language")
                }
            }
        }
        .sheetTopBar(title: "Create new vocabulary set", done: "**Create**", cancelFunc: {
            presentationMode.wrappedValue.dismiss()
        }, destructiveCancel: true, disabledFunc: { selectedLanguage == nil || setName == "" }) {
            modelContext.insert(VocabularySet(from: Language(name: selectedLanguage!.name), to: selectedLanguage!, name: setName, comment: comment))
            presentationMode.wrappedValue.dismiss()
        } // I'm sorry, this is not beautiful!
    }
}
