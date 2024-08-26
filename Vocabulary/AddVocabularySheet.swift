//
//  AddVocabularySheet.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct AddVocabularySheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let sectionId: UUID
    let fromLang: String
    let toLang: String
    
    @State private var from = ""
    @State private var to = ""
    @State private var classification = ""
    @State private var exampleFrom = ""
    @State private var exampleTo = ""
    @State private var comment = ""
    @State private var showInDict = true
    
    var body: some View {
        List {
            Section(toLang) {
                TextField("Write in \(toLang)", text: $to)
            }
            Section(fromLang) {
                TextField("Write in \(fromLang)", text: $from)
            }
            Section("Classification") {
                TextField("For Example *noun, plural*", text: $classification)
            }
            Section("Example in \(toLang)") {
                TextField("...", text: $exampleTo)
            }
            Section("Example in \(fromLang)") {
                TextField("...", text: $exampleFrom)
            }
            Section("Comment") {
                TextField("Do not use as...", text: $comment)
            }
            Section(footer: Text("This lets you find the word in the dictionary")) {
                Toggle("Show in dictionary", isOn: $showInDict)
            }
        }
        .sheetTopBar(title: "Add vocabulary", done: "**Add**", cancelFunc: {
            dismiss()
        }, destructiveCancel: true, disabledFunc: { false }) {
            modelContext.insert(Vocabulary(sectionId: sectionId, from: from, to: to, classification: classification, exampleFrom: exampleFrom, exampleTo: exampleTo, comment: comment, showInDict: showInDict))
            dismiss()
        }
    }
}
