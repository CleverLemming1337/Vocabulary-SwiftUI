//
//  SettingsView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @State private var deletionDialog = false
    @State private var errorDialog = false
    @State private var errorMessage = ""
    
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        List {
            Section(footer: Text("Delete all your data. This may be helpful in development or after an update. This action is irreversible.")) {
                Button("Delete all data", role: .destructive) {
                    deletionDialog = true
                }
            }
        }
        .confirmationDialog("Delete all data", isPresented: $deletionDialog, actions: {
            Button("Delete", role: .destructive) {
                do {
                    for model in MODELS {
                        try modelContext.delete(model: model)
                    }
                    try modelContext.save()
                }
                catch {
                    errorDialog = true
                    errorMessage = error.localizedDescription
                }
            }
            Button("Cancel", role: .cancel) { deletionDialog = false }
        }, message: { Text("You will delete all your data. This may be helpful in development or after an update. This action is irreversible.") })
        .alert(Text("An error occures"),
              isPresented: $errorDialog,
              actions: {
            Button("OK", role: .cancel) { errorDialog = false }
        }, message: {
            Text(errorMessage)
        })
    }
}

struct AboutView: View {
    var body: some View {
        List {
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                Section("Version") {
                    Text(version)
                }
            }
            if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                Section("Build") {
                    Text(build)
                }
            }
            Link(destination: URL(string: "https://github.com/CleverLemming1337/Vocabulary-Swift")!, label: { Text("View on GitHub") })
        }
        .navigationTitle("About this app")
    }
}

struct ComingSoonScreen: View {
    var body: some View {
        ContentUnavailableView("Coming soon", systemImage: "hammer.fill", description: Text("This feature is still in development."))
    }
}

struct ComingSoonLabel: View {
    var body: some View {
        Label("Coming soon", systemImage: "hammer.fill")
    }
}

#Preview {
    SettingsView()
}
