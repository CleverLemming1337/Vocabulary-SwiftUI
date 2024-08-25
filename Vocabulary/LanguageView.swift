//
//  LanguageView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import SwiftUI
import SwiftData

struct LanguageView: View {
    @Query var languages: [Language]
    @Environment(\.modelContext) var modelContext
    
    @State private var showSheet = false
    
    var body: some View {
        List {
            Button("Add", systemImage: "plus") {
                showSheet = true
            }
            ForEach(languages) { language in
                Text(language.name)
            }
            .onDelete(perform: { indexSet in
                for i in indexSet {
                    modelContext.delete(languages[i])
                }
            })
        }
        .navigationTitle("Your languages")
        .sheet(isPresented: $showSheet) {
            AddLangView()
        }
    }
}

#Preview {
    LanguageView()
}
