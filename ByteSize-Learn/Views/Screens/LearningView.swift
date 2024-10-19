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
    @State private var topCardOffset = CGSize.zero

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)

            // Cards
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                let isTopCard = index == cards.count - 1
                CardView(card: card)
                    .offset(y: isTopCard ? topCardOffset.height : CGFloat(cards.count - index) * 5)
                    .scaleEffect(isTopCard ? 1.0 : 1.0 - CGFloat(cards.count - index) * 0.01)
                    .rotationEffect(.degrees(isTopCard ? Double(topCardOffset.width / 20) : 0))
                    .gesture(
                        isTopCard ? DragGesture()
                            .onChanged { value in
                                self.topCardOffset = value.translation
                            }
                            .onEnded { value in
                                if value.translation.height < -100 { // Swiped up
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        self.topCardOffset.height = -1000
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        self.topCardOffset = .zero
                                        self.cards.removeLast()
                                        self.loadNextCard()
                                    }
                                } else {
                                    withAnimation {
                                        self.topCardOffset = .zero
                                    }
                                }
                            }
                        : nil
                    )
                    .allowsHitTesting(isTopCard)
                    .animation(.spring(), value: topCardOffset)
                    .zIndex(Double(index)) // Updated zIndex
            }
        }
        .onAppear {
            // Load initial cards when the view appears
            self.loadInitialCards()
        }
        .navigationTitle("Learning")
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    coordinator.popToRoot()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.primary)
                        .imageScale(.large)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(Color(UIColor.secondarySystemBackground))
                        )
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline) // Optional: makes the title look cleaner
    }

    // Function to load the initial cards based on the course
    func loadInitialCards() {
        // Replace this with actual content fetching logic
        self.cards = [
            CardModel(content: "Topic 1: \(course.name) Basics"),
            CardModel(content: "Topic 2: Advanced \(course.name)"),
            CardModel(content: "Topic 3: \(course.name) in Practice"),
            // Add more cards as needed
        ]
    }

    // Function to load the next card
    func loadNextCard() {
        // Fetch or generate the next card specific to the course
        let newCard = CardModel(content: "New Topic in \(course.name)")
        // Add the new card to the bottom of the stack
        self.cards.insert(newCard, at: 0)
    }
}
