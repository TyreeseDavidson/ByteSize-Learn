//
//  LongAnswerView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct LongAnswerView: View {
    let title: String
    let description: String
    let testCases: [CardModel.TestCase]
    let explanation: String
    
    @Binding var userAnswer: String
    @Binding var showFeedback: Bool
    @Binding var isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextEditor(text: $userAnswer)
                .frame(height: 150)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .background(Color.white)
                .cornerRadius(8)
            
            Button(action: {
                Task {
                    await validateAnswer()
                }
            }) {
                Text("Run Code")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue) // Updated color
                    .cornerRadius(10)
            }
            .disabled(userAnswer.isEmpty)
        }
    }
    
    private func validateAnswer() async {
            do {
                isCorrect = try await APIService.shared.validateLongAnswer(
                    title: title,
                    description: description,
                    testCases: testCases,
                    userAnswer: userAnswer,
                    explanation: explanation
                )
                showFeedback = true
            } catch {
                print("Validation failed: \(error)")
                showFeedback = true
                isCorrect = false
            }
        }
}
