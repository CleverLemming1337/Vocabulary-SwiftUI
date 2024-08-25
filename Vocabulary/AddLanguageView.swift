//
//  AddLanguageView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct AddLangView: View {
    @Binding var isPresented: Bool
    @State private var langName = ""
    @Environment(\.modelContext) var modelContext
    var body: some View {
        List {
            Section("Name") {
                TextField("Name", text: $langName)
            }
        }
        .sheetTopBar(title: "Create new language", done: "**Create**", cancelFunc: {
            isPresented = false
        }, destructiveCancel: true, disabledFunc: { langName == "" }) {
            modelContext.insert(Language(name: langName))
            isPresented = false
        } // I'm sorry, this is not beautiful!
    }
}
