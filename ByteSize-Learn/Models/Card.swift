//
//  Card.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

struct CardModel: Identifiable, Codable, Hashable {
    var id: UUID
    let title: String
    let description: String
    let type: CardType
    
    init(id: UUID = UUID(), title: String, description: String, type: CardType) {
        self.id = id
        self.title = title
        self.description = description
        self.type = type
    }
}
