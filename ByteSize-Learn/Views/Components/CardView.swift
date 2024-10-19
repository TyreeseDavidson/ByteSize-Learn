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
            
            Divider()
                .background(Color.white)
            
            // Dynamic Content Based on Card Type
            content
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
        case .text:
            Text(card.description)
                .font(.body)
                .foregroundColor(.white)
        
        case .multipleChoice(let options, let correctIndex):
            MultipleChoiceView(
                options: options,
                correctIndex: correctIndex,
                selectedOption: $selectedOption,
                showFeedback: $showFeedback,
                isCorrect: $isCorrect
            )
            .onChange(of: showFeedback) { newValue in
                if newValue {
                    onAnswer(isCorrect, card.explanation)
                }
            }
        
        case .trueFalse(let correctAnswer):
            TrueFalseView(
                correctAnswer: correctAnswer,
                selectedOption: $selectedOption,
                showFeedback: $showFeedback,
                isCorrect: $isCorrect
            )
            .onChange(of: showFeedback) { newValue in
                if newValue {
                    onAnswer(isCorrect, card.explanation)
                }
            }
        
        case .shortAnswer(let correctAnswer):
            ShortAnswerView(
                correctAnswer: correctAnswer,
                userAnswer: $userAnswer,
                showFeedback: $showFeedback,
                isCorrect: $isCorrect
            )
            .onChange(of: showFeedback) { newValue in
                if newValue {
                    onAnswer(isCorrect, card.explanation)
                }
            }
        
        case .longAnswer(let correctAnswer):
            LongAnswerView(
                correctAnswer: correctAnswer,
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

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleCard = SampleData.sampleCourse.cards[1]
//        CardView(card: sampleCard, onAnswer: { _, _ in })
//            .frame(width: 300, height: 500)
//    }
//}

