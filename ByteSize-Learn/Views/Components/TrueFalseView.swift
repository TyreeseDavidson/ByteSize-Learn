//
//  TrueFalseView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct TrueFalseView: View {
    let correctAnswer: Bool
    
    @Binding var selectedOption: Int?
    @Binding var showFeedback: Bool
    @Binding var isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button(action: {
                selectedOption = 1
                checkAnswer(selected: true)
            }) {
                HStack {
                    Text("True")
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            .disabled(selectedOption != nil)
            
            Button(action: {
                selectedOption = 0
                checkAnswer(selected: false)
            }) {
                HStack {
                    Text("False")
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
            }
            .disabled(selectedOption != nil)
        }
    }
    
    private func checkAnswer(selected: Bool) {
        isCorrect = (selected == correctAnswer)
        showFeedback = true
    }
}
