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
    @State private var allPreviousCards: [CardModel] = []
    
    // Popup State
    @State private var showPopup: Bool = false
    @State private var popupText: String = ""
    @State private var popupColor: Color = .green
    
    // User Performance Metrics
    @State private var correctCount: Int = 0
    @State private var incorrectCount: Int = 0
    
    // Card Generator
    @StateObject private var cardGenerator = CardGenerator()
    
    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            // Card Stack
            CardStackView(cards: cards, onSwipeUp: {
                // Handle swipe up: remove top card and load next
                if !cards.isEmpty {
                    setLastCardCorrect(isCorrect: 3)
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
            Task {
                await loadInitialCards()
            }
        }
        .navigationBarTitleDisplayMode(.inline) // Inline style for custom title
                .toolbar {
                    
                }
        .navigationBarBackButtonHidden(true) // Hide the default back button
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                CloseButtonView {
                    coordinator.navigateToHome()
                }
            }
            ToolbarItem(placement: .principal) {
                GradientText(text: course.name) // Custom gradient text title
                    .font(.system(size: 22, weight: .bold, design: .rounded))
            }
        }
        .navigationBarTitleDisplayMode(.inline) // Optional: makes the title look cleaner
    }

    // Function to load the initial cards based on the course
    private func loadInitialCards() async {
        // Assume course.cards already has some initial cards
        self.cards = course.cards
        self.allPreviousCards = course.cards
    }

    // Function to load the next card via the CardGenerator
    private func loadNextCard() {
        cardGenerator.enqueue(
            course: course,
            correctCount: correctCount,
            incorrectCount: incorrectCount,
            previousQuestions: allPreviousCards
        ) { result in
            switch result {
            case .success(let newCard):
                DispatchQueue.main.async {
                    self.cards.insert(newCard, at: 0)
                    self.allPreviousCards.append(newCard)
                }
            case .failure(let error):
                print("Error generating card: \(error)")
                Task {
                    await showError(message: "Failed to generate a new card. Please try again.")
                }
            }
        }
    }
    
    // Handle the answer result
    private func handleAnswer(isCorrect: Bool, explanation: String?) {
        // Update performance metrics
        if isCorrect {
            correctCount += 1
        } else {
            incorrectCount += 1
        }
        
        // Update card isCorrect
        setLastCardCorrect(isCorrect: isCorrect ? 1 : -1)
        
        // Update popup state
        popupText = isCorrect ? "Correct" : "Incorrect"
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
                    type: .Text,
                    title: "Explanation",
                    description: explanation,
                    answer: nil,
                    correctIndex: nil,
                    testCases: nil
                )
                cards.append(explanationCard)
            }
        }
    }
    
    // Function to show error popup
    private func showError(message: String) async {
        popupText = message
        popupColor = .red
        withAnimation {
            showPopup = true
        }
        
        // Hide after 2 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            withAnimation {
                showPopup = false
            }
        }
    }
    
    private func setLastCardCorrect(isCorrect: Int8) {
        if let lastIndex = cards.indices.last {
            cards[lastIndex].isCorrect = isCorrect
        }
    }
    
    struct GradientText: View {
        let text: String

        var body: some View {
            Text(text)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
        }
    }
    
    struct CloseButtonView: View {
        let action: () -> Void

        var body: some View {
            Button(action: action) {
                GradientText(text: "×") // Using a custom thicker "X"
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .padding(.horizontal, 4) // Optional padding for spacing
            }
            .accessibilityLabel("Close")
        }
    }
}
