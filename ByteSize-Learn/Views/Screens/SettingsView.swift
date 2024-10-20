//
//  SettingsView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var courseData: CourseData
    @EnvironmentObject private var coordinator: Coordinator
    @State private var isAddingCourse = false

    var body: some View {
        VStack {
            List {
                Section(header: Text("Manage Courses")) {
                    ForEach(courseData.courses, id: \.id) { course in
                        VStack(alignment: .leading) {
                            Text(course.name)
                                .font(.headline)
                            Text(course.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .onDelete(perform: courseData.removeCourse)

                    Button(action: {
                        isAddingCourse = true
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add New Course")
                        }
                    }
                }
            }

            Button("Save Changes") {
                courseData.saveCourses()
                coordinator.navigateToHome()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isAddingCourse) {
            AddCourseView { newCourse in
                Task {
                    do {
                        let fetchedCards = try await fetchCardsForCourse(course: newCourse)
                        let updatedCourse = Course(
                            name: newCourse.name,
                            description: newCourse.description,
                            cards: fetchedCards
                        )
                        courseData.addCourse(updatedCourse)
                    } catch {
                        print("Failed to fetch cards: \(error)")
                        // Optionally, handle the error (e.g., show an alert to the user)
                    }
                }
            }
        }
        .onAppear {
            courseData.loadCourses()
        }
    }

    private func fetchCardsForCourse(course: Course) async throws -> [CardModel] {
        var allFetchedCards: [CardModel] = []

        try await withThrowingTaskGroup(of: CardModel.self) { group in
            for _ in 1...5 {
                allFetchedCards.append (try await APIService.shared.generateCard(
                    courseTitle: course.name,
                    courseDescription: course.description,
                    correctCount: 0,
                    incorrectCount: 0,
                    previousQuestions: allFetchedCards
                )
                                        )
            }
            
//            for try await card in group {
//                allFetchedCards.append(card)
//            }
        }

        return allFetchedCards
    }
}
