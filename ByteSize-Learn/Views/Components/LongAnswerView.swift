//
//  LongAnswerView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct LongAnswerView: View {
    let correctAnswer: String // Expected code or description
    
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
                runCode()
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
    
    private func runCode() {
        // Placeholder for API call to run code
        // Simulate correctness based on whether userAnswer contains the correctAnswer substring
        if userAnswer.contains(correctAnswer) {
            isCorrect = true
        } else {
            isCorrect = false
        }
        showFeedback = true
    }
}
