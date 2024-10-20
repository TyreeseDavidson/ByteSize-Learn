//
//  CardGenerator.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation
import Combine

@MainActor
class CardGenerator: ObservableObject {
    @Published var isGenerating: Bool = false
    
    private var taskQueue = [Task<Void, Never>]()
    private var isProcessing = false
    
    /// Enqueues a card generation request.
    /// - Parameters:
    ///   - course: The course for which to generate the card.
    ///   - correctCount: Number of correct answers so far.
    ///   - incorrectCount: Number of incorrect answers so far.
    ///   - previousQuestions: List of previously generated cards.
    ///   - completion: Closure to be called with the result of card generation.
    func enqueue(
        course: Course,
        correctCount: Int,
        incorrectCount: Int,
        previousQuestions: [CardModel],
        completion: @escaping (Result<CardModel, Error>) -> Void
    ) {
        let task = Task {
            await generateCard(
                course: course,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                previousQuestions: previousQuestions,
                completion: completion
            )
        }
        taskQueue.append(task)
        processQueue()
    }
    
    /// Processes the next task in the queue.
    private func processQueue() {
        guard !isProcessing, !taskQueue.isEmpty else { return }
        isProcessing = true
        let currentTask = taskQueue.removeFirst()
        Task {
            await currentTask.value
            await markTaskComplete()
        }
    }
    
    /// Marks the current task as complete and processes the next one.
    private func markTaskComplete() {
        isProcessing = false
        processQueue()
    }
    
    /// Generates a new card by calling the API service.
    private func generateCard(
        course: Course,
        correctCount: Int,
        incorrectCount: Int,
        previousQuestions: [CardModel],
        completion: @escaping (Result<CardModel, Error>) -> Void
    ) async {
        isGenerating = true
        do {
            let newCard = try await APIService.shared.generateCard(
                courseTitle: course.name,
                courseDescription: course.description,
                correctCount: correctCount,
                incorrectCount: incorrectCount,
                previousQuestions: previousQuestions
            )
            completion(.success(newCard))
        } catch {
            completion(.failure(error))
        }
        isGenerating = false
    }
}

