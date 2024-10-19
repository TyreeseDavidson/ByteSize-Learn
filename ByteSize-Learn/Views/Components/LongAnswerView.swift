//
//  LongAnswerView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct LongAnswerView: View {
    let correctAnswer: String // This could be the expected code or a description
    
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
            
            HStack {
                Button(action: {
                    runCode()
                }) {
                    Text("Run Code")
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .disabled(userAnswer.isEmpty)
            }
        }
    }
    
    private func runCode() {
        // Placeholder for API call to run code
        // For now, simulate a correct or incorrect response
        
        // Simple simulation: Check if userAnswer contains the correctAnswer substring
        if userAnswer.contains(correctAnswer) {
            isCorrect = true
        } else {
            isCorrect = false
        }
        showFeedback = true
    }
}

