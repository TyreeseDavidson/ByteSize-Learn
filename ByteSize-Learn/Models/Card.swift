//
//  Card.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

enum CardType: String, Codable, Hashable {
    case TrueFalse
    case MultipleChoice
    case ShortAnswer
    case LongAnswer
    case Text
}

struct CardModel: Identifiable, Codable, Hashable {
    let id: UUID
    let type: CardType
    let title: String
    let description: String
    let truefalse: Bool? // Applicable for True/False
    let answer: String? // Applicable for Short Answer
    let options: [String]? // Applicable for Multiple Choice
    let correctIndex: Int? // Applicable for MultipleChoice
    let testCases: [TestCase]? // Applicable for LongAnswer
    let explanation: String?
    var isCorrect: Int8?
    
    struct TestCase: Codable, Hashable {
        let input: String
        let output: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        
        self.type = try container.decode(CardType.self, forKey: .type)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.truefalse = try container.decodeIfPresent(Bool.self, forKey: .truefalse)
        self.answer = try container.decodeIfPresent(String.self, forKey: .answer)
        self.options = try container.decodeIfPresent([String].self, forKey: .options)
        self.correctIndex = try container.decodeIfPresent(Int.self, forKey: .correctIndex)
        self.testCases = try container.decodeIfPresent([TestCase].self, forKey: .testCases)
        self.explanation = try container.decodeIfPresent(String.self, forKey: .explanation)
        self.isCorrect = 0
    }
    
    init(id: UUID = UUID(), type: CardType, title: String, description: String, truefalse: Bool? = nil, answer: String? = nil, options: [String]? = nil, correctIndex: Int? = nil, testCases: [TestCase]? = nil, explanation: String? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.description = description
        self.truefalse = truefalse
        self.answer = answer
        self.options = options
        self.correctIndex = correctIndex
        self.testCases = testCases
        self.explanation = explanation
        self.isCorrect = 0
    }
}
