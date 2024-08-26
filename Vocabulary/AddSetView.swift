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
    @State private var selectToLang = false
    @State private var selectFromLang = false
    @State private var toLanguage: Language? = nil
    @State private var fromLanguage: Language? = nil
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
                Button(toLanguage?.name ?? "Select language") {
                    selectToLang = true
                }
                .sheet(isPresented: $selectToLang) {
                    SelectLanguageView(isPresented: $selectToLang, selectedLanguage: $toLanguage)
                        .navigationTitle("Select language")
                }
            }
            Section(header: Text("From language"), footer: Text("This is the language from which you learn the vocabulary, for example English.")) {
                Button(fromLanguage?.name ?? "Select language") {
                    selectFromLang = true
                }
                .sheet(isPresented: $selectFromLang) {
                    SelectLanguageView(isPresented: $selectFromLang, selectedLanguage: $fromLanguage)
                        .navigationTitle("Select language")
                }
            }
        }
        .sheetTopBar(title: "Create new vocabulary set", done: "**Create**", cancelFunc: {
            presentationMode.wrappedValue.dismiss()
        }, destructiveCancel: true, disabledFunc: { toLanguage == nil || fromLanguage == nil || setName == "" }) {
            modelContext.insert(VocabularySet(from: fromLanguage!.name, to: toLanguage!.name, name: setName, comment: comment))
            presentationMode.wrappedValue.dismiss()
        } // I'm sorry, this is not beautiful!
    }
}
