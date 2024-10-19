//
//  CardType.swift
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
    case longAnswer(correctAnswer: String) // For coding challenges
}
