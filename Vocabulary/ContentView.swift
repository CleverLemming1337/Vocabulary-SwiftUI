import SwiftUI
import SwiftData


struct ContentView: View {
    var body: some View {
        NavigationSplitView(sidebar: {
            List {
                Section("Learn") {
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Today", systemImage: "doc.text.image.fill") })
                    NavigationLink(destination: VocabularySetList(), label: { Label("Vocabulary sets", systemImage: "rectangle.stack.fill") })
                }
                Section("Dictionary") {
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Your vocabulary", systemImage: "book.closed.fill") })
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Dictionary", systemImage: "book.closed") })
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Translate", systemImage: "translate") })
                }
                Section("More") {
                    NavigationLink(destination: SettingsView(), label: { Label("Settings", systemImage: "gear") })
                    NavigationLink(destination: AboutView(), label: { Label("About this app", systemImage: "info.circle") })
                }
            }
            .navigationTitle("Vocabulary")
        }, detail: {
            VocabularySetList()
        })
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [VocabularySet.self, Vocabulary.self, Language.self], inMemory: true)
}
