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
                ], correctIndex: 0),
                explanation: "SwiftUI is primarily used for building user interfaces across all Apple platforms."
            ),
            CardModel(
                title: "Declarative UI",
                description: "SwiftUI uses a declarative syntax.",
                type: .trueFalse(correctAnswer: true),
                explanation: "Declarative syntax allows you to state what your UI should do."
            ),
            CardModel(
                title: "SwiftUI Views",
                description: "Create a view in SwiftUI by using the ______ protocol.",
                type: .shortAnswer(correctAnswer: "View"),
                explanation: "The 'View' protocol is used to create views in SwiftUI."
            ),
            CardModel(
                title: "Simple Counter",
                description: "Write a simple SwiftUI view that increments a counter when a button is pressed.",
                type: .longAnswer(correctAnswer: "Counter"),
                explanation: "A simple counter view would have a @State variable 'counter' that increments on button press."
            )
        ]
    )
}

