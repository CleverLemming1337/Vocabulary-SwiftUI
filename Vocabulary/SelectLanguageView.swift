//
//  SelectLanguageView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftUI
import SwiftData

struct SelectLanguageView: View {
    @Binding var isPresented: Bool
    @Binding var selectedLanguage: Language?
    @Query var languages: [Language]
    @State private var langName = ""
    @State private var addLang = false
    
    var body: some View {
        List {
            ForEach(languages, id: \.self) { lang in
                Button(lang.name) {
                    selectedLanguage = Language(name: lang.name)
                    isPresented = false
                }
                .tint(.primary)
            }
            Button("Add language", systemImage: "plus") {
                addLang = true
            }
        }
        .sheetTopBar(title: "Select language", done: "**Create**", cancelFunc: {
            isPresented = false
        })
        .sheet(isPresented: $addLang) {
            AddLangView()
        }
        
    }
}
