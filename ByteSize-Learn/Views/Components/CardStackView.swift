//
//  CardStackView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct CardStackView: View {
    let cards: [CardModel]
    let onSwipeUp: () -> Void
    let onAnswer: (Bool, String?) -> Void // Closure to handle answer results

    @State private var topCardOffset = CGSize.zero

    var body: some View {
        ZStack {
            ForEach(cards) { card in
                let isTopCard = card.id == cards.last?.id
                CardView(card: card, onAnswer: { isCorrect, explanation in
                    onAnswer(isCorrect, explanation)
                })
                .offset(y: isTopCard ? topCardOffset.height : CGFloat(cards.count - 1 - (cards.firstIndex(where: { $0.id == card.id }) ?? 0)) * 5)
                .scaleEffect(isTopCard ? 1.0 : 1.0 - CGFloat(cards.count - 1 - (cards.firstIndex(where: { $0.id == card.id }) ?? 0)) * 0.01)
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
                                    onSwipeUp()
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
                .zIndex(isTopCard ? 1 : 0) // Ensures the top card is on top
            }
        }
    }
}

//struct CardStackView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleCourse = SampleData.sampleCourse
//        CardStackView(cards: sampleCourse.cards, onSwipeUp: {}, onAnswer: { _, _ in })
//            .frame(width: 300, height: 500)
//    }
//}
