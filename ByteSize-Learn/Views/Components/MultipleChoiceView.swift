//
//  MultipleChoiceView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct MultipleChoiceView: View {
    let options: [String]
    let correctIndex: Int
    
    @Binding var selectedOption: Int?
    @Binding var showFeedback: Bool
    @Binding var isCorrect: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(0..<options.count, id: \.self) { index in
                Button(action: {
                    selectedOption = index
                    checkAnswer(selected: index)
                }) {
                    HStack {
                        Text(options[index])
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
    }
    
    private func checkAnswer(selected: Int) {
        isCorrect = (selected == correctIndex)
        showFeedback = true
    }
}
