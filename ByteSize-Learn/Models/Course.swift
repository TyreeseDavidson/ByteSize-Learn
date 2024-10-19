//
//  Course.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

struct Course: Hashable, Codable, Identifiable {
    let name: String
    let description: String
    let cards: [CardModel]
    
    init(name: String, description: String, cards: [CardModel] = []) {
        self.name = name
        self.description = description
        self.cards = cards
    }
}
