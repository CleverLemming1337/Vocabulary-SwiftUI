import SwiftUI
import SwiftData

@Model class VocabularySet {
    let name: String
    let comment: String
    let sections: [VocabularySection]
    let from: Language
    let to: Language
    
    init(from: Language, to: Language, name: String, comment: String, sections: [VocabularySection]) {
        self.name = name
        self.comment = comment
        self.sections = sections
        self.from = from
        self.to = to
    }
}

@Model class VocabularySection {
    let vocabulary: [UUID]
    
    init(vocabulary: [UUID]) {
        self.vocabulary = vocabulary
    }
}

@Model class Vocabulary {
    let id: UUID
    let clasification: String?
    let exampleFrom: String?
    let exampleTo: String?
    let comment: String?
    let showInDict: Bool
    
    init(classification: String?, exampleFrom: String?, exampleTo: String?, comment: String?, showInDict: Bool) {
        self.id = UUID()
        self.clasification = classification
        self.exampleFrom = exampleFrom
        self.exampleTo = exampleTo
        self.comment = comment
        self.showInDict = showInDict
    }
}

@Model class Language {
    let name: String
    
    init(name: String) {
        self.name = name
    }
}

@Model class Tag {
    @Attribute(.unique) let name: String
    let vocabulary: [UUID]
    
    init(name: String, vocabulary: [UUID]) {
        self.name = name
        self.vocabulary = vocabulary
    }
}
struct ContentView: View {
    var body: some View {
        NavigationSplitView(sidebar: {
            List {
                Section("Learn") {
                    NavigationLink(destination: ContentUnavailableView("Coming soon", systemImage: "hammer.fill", description: Text("This feature is still in development.")), label: { Label("Today", systemImage: "doc.text.image.fill") })
                    NavigationLink(destination: VocabularySetView(), label: { Label("Vocabulary sets", systemImage: "rectangle.stack.fill") })
                }
                Section("Dictionary") {
                    NavigationLink(destination: ContentUnavailableView("Coming soon", systemImage: "hammer.fill", description: Text("This feature is still in development.")), label: { Label("Search", systemImage: "book.closed.fill") })
                    NavigationLink(destination: ContentUnavailableView("Coming soon", systemImage: "hammer.fill", description: Text("This feature is still in development.")), label: { Label("Translate", systemImage: "translate") })
                }
                Section("More") {
                    NavigationLink(destination: ContentUnavailableView("Coming soon", systemImage: "hammer.fill", description: Text("This feature is still in development.")), label: { Label("Settings", systemImage: "gear") })
                    NavigationLink(destination: AboutView(), label: { Label("About this app", systemImage: "info.circle") })
                }
            }
            .navigationTitle("Vocabulary")
        }, detail: {
            VocabularySetView()
        })
    }
}

struct VocabularySetView: View {
    @Query var vocabularySets: [VocabularySet]
    @Environment(\.modelContext) var modelContext
    @State private var addSet = false
    var body: some View {
        List {
            ForEach(vocabularySets) { set in
                NavigationLink(destination: Text(set.name)) {
                    Text(set.name)
                }
            }
            Button("Add", systemImage: "plus") {
                addSet = true
            }
        }
        .sheet(isPresented: $addSet) {
            AddSetView()
            
                .presentationBackgroundInteraction(.automatic)
                .presentationDetents([.large, .medium])
                .presentationBackgroundInteraction(.automatic)
                .navigationTitle("Create new set")
        }
        .navigationTitle("Vocabulary sets")
    }
}


struct AddSetView: View {
    @Environment(\.modelContext) var modelContext
    @Query var languages: [Language]
    @State private var addLang = false
    @State private var selectedLanguage: Language? = nil
    @State private var setName: String = ""
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
            List {
                Section("Name") {
                    TextField("Set name", text: $setName)
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
                modelContext.insert(VocabularySet(from: Language(name: selectedLanguage!.name), to: selectedLanguage!, name: setName, comment: "", sections: []))
                presentationMode.wrappedValue.dismiss()
            } // I'm sorry, this is not beautiful!
    }
}

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
            AddLangView(isPresented: $addLang)
        }

    }
}

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
#Preview {
    ContentView()
        .modelContainer(for: [VocabularySet.self, Vocabulary.self, Language.self], inMemory: true)
}
