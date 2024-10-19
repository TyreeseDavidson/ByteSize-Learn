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
}
