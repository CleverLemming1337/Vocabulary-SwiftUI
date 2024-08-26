//
//  Models.swift
//  Vocabulary
//
//  Created by Leonard Fekete on 25.08.24.
//

import Foundation
import SwiftData

@Model class VocabularySet {
    let name: String
    let comment: String
    let sections: [VocabularySection]
    let from: String // working with Language UUIDs does not work, therefore using Language names
    let to: String
    
    init(from: String, to: String, name: String, comment: String) {
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
