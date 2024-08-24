import SwiftUI
import SwiftData

@Model class VocabularySet {
    let name: String
    let comment: String
    let sections: [VocabularySection]
    let from: Language
    let to: Language
    
    init(from: Language, to: Language, name: String, comment: String) {
        self.name = name
        self.comment = comment
        self.from = from
        self.to = to
        
        self.sections = [
            VocabularySection(number: 1),
            VocabularySection(number: 2),
            VocabularySection(number: 3),
            VocabularySection(number: 4),
            VocabularySection(number: 5),
            VocabularySection(number: 6),
            VocabularySection(number: 7)
        ]
    }
}

@Model class VocabularySection {
    let id = UUID()
    let number: UInt
    
    init(number: UInt) {
        self.number = number
    }
}

@Model class Vocabulary {
    let sectionId: UUID?
    let from: String
    let to: String
    let clasification: String?
    let exampleFrom: String?
    let exampleTo: String?
    let comment: String?
    let showInDict: Bool
    
    init(sectionId: UUID?, from: String, to: String, classification: String?, exampleFrom: String?, exampleTo: String?, comment: String?, showInDict: Bool) {
        self.sectionId = sectionId
        self.from = from
        self.to = to
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
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Today", systemImage: "doc.text.image.fill") })
                    NavigationLink(destination: VocabularySetList(), label: { Label("Vocabulary sets", systemImage: "rectangle.stack.fill") })
                }
                Section("Dictionary") {
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Search", systemImage: "book.closed.fill") })
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Translate", systemImage: "translate") })
                }
                Section("More") {
                    NavigationLink(destination: ComingSoonScreen(), label: { Label("Settings", systemImage: "gear") })
                    NavigationLink(destination: AboutView(), label: { Label("About this app", systemImage: "info.circle") })
                }
            }
            .navigationTitle("Vocabulary")
        }, detail: {
            VocabularySetList()
        })
    }
}

struct VocabularySetList: View {
    @Query var vocabularySets: [VocabularySet]
    @Environment(\.modelContext) var modelContext
    @State private var addSet = false
    var body: some View {
        NavigationStack {
            List {
                ForEach(vocabularySets) { set in
                    NavigationLink(destination: VocabularySetView(set: set)) {
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
}


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

struct VocabularySetView: View {
    let set: VocabularySet
    @Query var vocabulary: [Vocabulary]
    var body: some View {
        List {
            Section("Pinned words") {
                ComingSoonLabel()
            }
            Section("Weak words") {
                ComingSoonLabel()
            }
            Section("Sections") {
                ForEach(set.sections.sorted(by: { $0.number < $1.number }), id: \.self) { section in
                    NavigationLink(destination: { VocabularySectionView(fromLang: set.from, toLang: set.to, section: section) }) {
                        Text("\(section.number)")
                    }
                }
            }
        }
        .navigationTitle(set.name)
    }
}

struct VocabularySectionView: View {
    let fromLang: Language
    let toLang: Language
    let section: VocabularySection
    @Query var vocabularies: [Vocabulary]
    
    @State private var addVocabularySheet = false
    var body: some View {
        List {
            Button("Add", systemImage: "plus") {
                addVocabularySheet = true
            }
            ForEach(vocabularies.filter { $0.sectionId == section.id }) { voc in
                VStack(alignment: .leading) {
                    Text(voc.to)
                    Text(voc.from)
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("Section \(section.number)")
        .sheet(isPresented: $addVocabularySheet) {
            AddVocabularySheet(sectionId: section.id, fromLang: fromLang, toLang: toLang)
        }
    }
}

struct AddVocabularySheet: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    let sectionId: UUID
    let fromLang: Language
    let toLang: Language
    
    @State private var from = ""
    @State private var to = ""
    @State private var classification = ""
    @State private var exampleFrom = ""
    @State private var exampleTo = ""
    @State private var comment = ""
    @State private var showInDict = true

    var body: some View {
        List {
            Section(toLang.name) {
                TextField("Write in \(toLang)", text: $to)
            }
            Section(fromLang.name) {
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
    ContentView()
        .modelContainer(for: [VocabularySet.self, Vocabulary.self, Language.self], inMemory: true)
}
