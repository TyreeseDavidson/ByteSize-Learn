//
//  CloseButtonView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct CloseButtonView: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "xmark")
                .foregroundColor(.primary)
                .imageScale(.large)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color(UIColor.secondarySystemBackground))
                )
        }
        .accessibilityLabel("Close")
    }
}
