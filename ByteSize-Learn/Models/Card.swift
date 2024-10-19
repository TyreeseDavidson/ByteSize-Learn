//
//  Card.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

enum CardType: Codable, Hashable {
    case text
    case multipleChoice(options: [String], correctIndex: Int)
    case trueFalse(correctAnswer: Bool)
    case shortAnswer(correctAnswer: String)
    case longAnswer(correctAnswer: String)
}

struct CardModel: Identifiable, Codable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let type: CardType
    let explanation: String?
    
    init(id: UUID = UUID(), title: String, description: String, type: CardType, explanation: String? = nil) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
        self.explanation = explanation
    }
}
