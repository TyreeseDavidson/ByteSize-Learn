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
    
    // Popup State
    @State private var showPopup: Bool = false
    @State private var popupText: String = ""
    @State private var popupColor: Color = .green
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            // Card Stack
            CardStackView(cards: cards, onSwipeUp: {
                // Handle swipe up: remove top card and load next
                if !cards.isEmpty {
                    cards.removeLast()
                    loadNextCard()
                }
            }, onAnswer: { isCorrect, explanation in
                handleAnswer(isCorrect: isCorrect, explanation: explanation)
            })
            
            // Popup Overlay
            if showPopup {
                PopupView(text: popupText, color: popupColor)
                    .zIndex(1) // Ensure it's above other views
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
        // Placeholder for API call to fetch new card
        fetchNewCard { newCard in
            DispatchQueue.main.async {
                self.cards.insert(newCard, at: 0) // Insert at front, bottom of deck
            }
        }
    }
    
    // Handle the answer result
    private func handleAnswer(isCorrect: Bool, explanation: String?) {
        // Update popup state
        popupText = isCorrect ? "Correct ✅" : "Incorrect ❌"
        popupColor = isCorrect ? .green : .red
        withAnimation {
            showPopup = true
        }
        
        // After 1 second, hide popup and proceed
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation {
                showPopup = false
            }
            
            // Remove the top card
            if !cards.isEmpty {
                cards.removeLast()
            }
            
            if isCorrect {
                // Proceed to next card
                loadNextCard()
            } else if let explanation = explanation {
                // Insert explanation card at top
                let explanationCard = CardModel(
                    title: "Explanation",
                    description: explanation,
                    type: .text
                )
                cards.append(explanationCard)
            }
        }
    }
    
    // Placeholder function for API call to fetch a new card
    private func fetchNewCard(completion: @escaping (CardModel) -> Void) {
        // Simulate network delay
        DispatchQueue.global().asyncAfter(deadline: .now() + 1.0) {
            // Create a dummy new card
            let newCard = CardModel(
                title: "New Topic",
                description: "This is a new card fetched from the API.",
                type: .text,
                explanation: "Explanation for the new topic."
            )
            completion(newCard)
        }
    }
}
