//
//  ShortAnswerView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct ShortAnswerView: View {
    let correctAnswer: String
    
    @Binding var userAnswer: String
    @Binding var showFeedback: Bool
    @Binding var isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            TextField("Your Answer", text: $userAnswer)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disableAutocorrection(true)
            
            Button(action: {
                checkAnswer()
            }) {
                Text("Submit")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .disabled(userAnswer.isEmpty)
        }
    }
    
    private func checkAnswer() {
        isCorrect = (userAnswer.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == correctAnswer.lowercased())
        showFeedback = true
    }
}

