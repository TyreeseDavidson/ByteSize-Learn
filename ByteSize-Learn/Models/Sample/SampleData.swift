//
//  SampleData.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

struct SampleData {
    static let sampleCourse = Course(
        name: "SwiftUI Essentials",
        description: "Learn the fundamentals of SwiftUI.",
        cards: [
            CardModel(
                title: "Welcome",
                description: "This is a text-based card introducing the course.",
                type: .text
            ),
            CardModel(
                title: "SwiftUI Basics",
                description: "What is SwiftUI primarily used for?",
                type: .multipleChoice(options: [
                    "Building user interfaces",
                    "Networking",
                    "Data Persistence",
                    "Machine Learning"
                ], correctIndex: 0)
            ),
            CardModel(
                title: "Declarative UI",
                description: "SwiftUI uses a declarative syntax.",
                type: .trueFalse(correctAnswer: true)
            ),
            CardModel(
                title: "SwiftUI Views",
                description: "Create a view in SwiftUI by using the ______ protocol.",
                type: .shortAnswer(correctAnswer: "View")
            ),
            CardModel(
                title: "Simple Counter",
                description: "Write a simple SwiftUI view that increments a counter when a button is pressed.",
                type: .longAnswer(correctAnswer: "Counter")
            )
        ]
    )
}

