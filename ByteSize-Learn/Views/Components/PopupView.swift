//
//  PopupView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct PopupView: View {
    let text: String
    let color: Color
    
    var body: some View {
        Text(text)
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(color.opacity(0.85))
            .cornerRadius(12)
            .shadow(radius: 10)
            .padding()
            .transition(.scale)
            .animation(.easeInOut(duration: 0.3), value: text)
    }
}
