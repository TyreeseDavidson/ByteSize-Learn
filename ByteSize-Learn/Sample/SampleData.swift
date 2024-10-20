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
            // Multiple Choice Card
            CardModel(
                type: .MultipleChoice,
                title: "SwiftUI Basics",
                description: "What is SwiftUI primarily used for?",
                options: [
                    "Building user interfaces",
                    "Networking",
                    "Data Persistence",
                    "Machine Learning"
                ],
                correctIndex: 0,
                explanation: "SwiftUI is primarily used for building user interfaces across all Apple platforms."
            ),

            // True/False Card
            CardModel(
                type: .TrueFalse,
                title: "Declarative UI",
                description: "SwiftUI uses a declarative syntax.",
                truefalse: true,
                explanation: "Declarative syntax allows you to state what your UI should do."
            ),

            // Short Answer Card
            CardModel(
                type: .ShortAnswer,
                title: "SwiftUI Views",
                description: "Create a view in SwiftUI by using the ______ protocol.",
                answer: "View",
                explanation: "The 'View' protocol is used to create views in SwiftUI."
            ),

            // Long Answer (Coding) Card
            CardModel(
                type: .LongAnswer,
                title: "Simple Counter",
                description: "Write a simple SwiftUI view that increments a counter when a button is pressed.",
                testCases: [
                    CardModel.TestCase(input: "Tap button 1 time", output: "Counter: 1"),
                    CardModel.TestCase(input: "Tap button 3 times", output: "Counter: 3")
                ],
                explanation: "A simple counter view uses a @State variable 'counter' that increments on button press."
            )
        ]
    )
}
