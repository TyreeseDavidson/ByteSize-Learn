//
//  LearningView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct LearningView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let course: Course

    @State private var cards: [CardModel] = []
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            // Card Stack
            CardStackView(cards: cards) {
                // Handle swipe up: remove top card and load next
                if !cards.isEmpty {
                    cards.removeLast()
                    loadNextCard()
                }
            }
        }
        .onAppear {
            loadInitialCards()
        }
        .navigationTitle("Learning")
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CloseButtonView {
                    coordinator.popToRoot()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline) // Optional: makes the title look cleaner
    }

    // Function to load the initial cards based on the course
    private func loadInitialCards() {
        // Replace this with actual content fetching logic or API call
        self.cards = course.cards
    }

    // Function to load the next card
    private func loadNextCard() {
        // Fetch or generate the next card specific to the course
        // For demonstration, we'll just shuffle the existing cards
        self.cards.shuffle()
    }
}

