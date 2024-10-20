//
//  CardView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct CardView: View {
    let card: CardModel
    let onAnswer: (Bool, String?) -> Void // Closure to notify answer result

    // State variables for user interactions
    @State private var selectedOption: Int? = nil
    @State private var userAnswer: String = ""
    @State private var showFeedback: Bool = false
    @State private var isCorrect: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Card Title
            Text(card.title)
                .font(.headline)
                .foregroundColor(.white)
            
            // Card Description
            Text(card.description)
                .font(.subheadline)
                .foregroundColor(.white)
            
            if card.type == CardType.LongAnswer && card.testCases != nil {
                ForEach(card.testCases!, id: \.input) { testCase in
                    Text("Input: \(testCase.input) → Output: \(testCase.output)")
                        .foregroundColor(.white)
                }
            }
            
            if card.type != CardType.Text {
                Divider()
                    .background(Color.white)
                
                // Dynamic Content Based on Card Type
                content
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(25)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
    
    @ViewBuilder
    private var content: some View {
        switch card.type {
        case .Text:
            Text(card.description)
                .font(.body)
                .foregroundColor(.white)
        
        case .MultipleChoice:
            MultipleChoiceView(
                options: card.options!,
                correctIndex: card.correctIndex!,
                selectedOption: $selectedOption,
                showFeedback: $showFeedback,
                isCorrect: $isCorrect
            )
            .onChange(of: showFeedback) { newValue in
                if newValue {
                    onAnswer(isCorrect, card.explanation)
                }
            }
        
        case .TrueFalse:
            TrueFalseView(
                correctAnswer: card.truefalse!,
                selectedOption: $selectedOption,
                showFeedback: $showFeedback,
                isCorrect: $isCorrect
            )
            .onChange(of: showFeedback) { newValue in
                if newValue {
                    onAnswer(isCorrect, card.explanation)
                }
            }
        
        case .ShortAnswer:
            ShortAnswerView(
                correctAnswer: card.answer!,
                userAnswer: $userAnswer,
                showFeedback: $showFeedback,
                isCorrect: $isCorrect
            )
            .onChange(of: showFeedback) { newValue in
                if newValue {
                    onAnswer(isCorrect, card.explanation)
                }
            }
        
        case .LongAnswer:
            LongAnswerView(
                title: card.title,
                description: card.description,
                testCases: card.testCases ?? [CardModel.TestCase(input: "N/A", output: "N/A")],
                explanation: card.explanation!,
                userAnswer: $userAnswer,
                showFeedback: $showFeedback,
                isCorrect: $isCorrect
            )
            .onChange(of: showFeedback) { newValue in
                if newValue {
                    onAnswer(isCorrect, card.explanation)
                }
            }
        }
    }
}
