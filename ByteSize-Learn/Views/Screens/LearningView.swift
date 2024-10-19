//
//  LearningView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct Course: Hashable, Codable {
    let name: String
    let description: String
}

struct LearningView: View {
    @EnvironmentObject private var coordinator: Coordinator
    let course: Course

    @State private var cards: [CardViewModel] = []
    @State private var topCardOffset = CGSize.zero

    var body: some View {
        ZStack {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)

            // Cards
            ForEach(Array(cards.enumerated()), id: \.element.id) { index, card in
                let isTopCard = index == cards.count - 1
                CardView(card: card)
                    .offset(y: isTopCard ? topCardOffset.height : CGFloat(cards.count - index) * 10)
                    .scaleEffect(isTopCard ? 1.0 : 1.0 - CGFloat(cards.count - index) * 0.02)
                    .rotationEffect(.degrees(isTopCard ? Double(topCardOffset.width / 20) : 0))
                    .animation(.spring(), value: topCardOffset)
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
                    .zIndex(Double(index) * -1) // Ensure the top card is on top
            }

            // Top Bar with Back Button and Course Info
            VStack {
                HStack {
                    Button(action: {
                        coordinator.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)

            // Course Information
            VStack {
                Text(course.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 80)
                Text(course.description)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .multilineTextAlignment(.center)
                Spacer()
            }
            .zIndex(1) // Ensure the course info is above the cards
        }
        .onAppear {
            // Load initial cards when the view appears
            self.loadInitialCards()
        }
    }

    // Function to load the initial cards based on the course
    func loadInitialCards() {
        // Replace this with actual content fetching logic
        self.cards = [
            CardViewModel(content: "\(course.name) Topic 1"),
            CardViewModel(content: "\(course.name) Topic 2"),
            CardViewModel(content: "\(course.name) Topic 3"),
            // Add more cards as needed
        ]
    }

    // Function to load the next card
    func loadNextCard() {
        // Fetch or generate the next card specific to the course
        let newCard = CardViewModel(content: "New \(course.name) Topic")
        // Add the new card to the bottom of the stack
        self.cards.insert(newCard, at: 0)
    }
}

//#Preview {
//    let sampleCourse = Course(
//        name: "Mathematics",
//        description: "Learn the fundamentals of mathematics."
//    )
//    LearningView(course: sampleCourse)
//        .environmentObject(Coordinator())
//}
