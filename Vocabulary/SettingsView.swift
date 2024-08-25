//
//  SettingsView.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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
