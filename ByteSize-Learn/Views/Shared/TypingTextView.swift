//
//  TypingTextView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI
import Combine

struct TypingTextView: View {
    let text: String
    let characterDelay: TimeInterval
    @State private var displayedText: String = ""
    @State private var cancellable: AnyCancellable?

    init(text: String, characterDelay: TimeInterval = 0.05) {
        self.text = text
        self.characterDelay = characterDelay
    }

    var body: some View {
        Text(displayedText)
            .onAppear {
                startTyping()
            }
            .onDisappear {
                cancellable?.cancel()
            }
    }

    private func startTyping() {
        displayedText = ""
        let characters = Array(text)
        var currentIndex = 0

        cancellable = Timer.publish(every: characterDelay, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if currentIndex < characters.count {
                    displayedText.append(characters[currentIndex])
                    currentIndex += 1
                } else {
                    cancellable?.cancel()
                }
            }
    }
}

