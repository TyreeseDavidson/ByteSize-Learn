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
    @State private var isLoading = false // Track loading state

    var body: some View {
        VStack {
            if isLoading {
                LoadingView(message: "Generating course cards...")
            } else {
                // Course Management Section
                List {
                    Section(header: Text("Manage Courses")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    ) {
                        ForEach(courseData.courses, id: \.id) { course in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(course.name)
                                    .font(.headline)
                                Text(course.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .onDelete(perform: courseData.removeCourse)

                        // Add New Course Button
                        Button(action: { isAddingCourse = true }) {
                            Label("Add New Course", systemImage: "plus.circle.fill")
                                .font(.body)
                                .foregroundColor(.blue)
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())

                // Save Changes Button with Gradient
                GradientButton(title: "Save Changes") {
                    courseData.saveCourses()
                    coordinator.navigateToHome()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isAddingCourse) {
            AddCourseView { newCourse in
                isLoading = true // Start loading
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
                    }
                    isLoading = false // Stop loading
                }
            }
        }
        .onAppear { courseData.loadCourses() }
    }

    // Helper Function for Fetching Cards
    private func fetchCardsForCourse(course: Course) async throws -> [CardModel] {
        var allFetchedCards: [CardModel] = []

        try await withThrowingTaskGroup(of: CardModel.self) { group in
            for _ in 1...5 {
                let card = try await APIService.shared.generateCard(
                    courseTitle: course.name,
                    courseDescription: course.description,
                    correctCount: 0,
                    incorrectCount: 0,
                    previousQuestions: allFetchedCards
                )
                allFetchedCards.append(card)
            }
        }

        return allFetchedCards
    }
}

// Gradient Button Component
struct GradientButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [.blue, .purple]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(12)
        }
    }
}

// Modern Loading View
struct LoadingView: View {
    let message: String

    var body: some View {
        VStack(spacing: 16) {
            // Gradient ProgressView
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask(
                ProgressView()
                    .scaleEffect(1.5)
            )
            .frame(width: 50, height: 50) // Fix size to ensure mask aligns properly

            // Gradient Text
            LinearGradient(
                gradient: Gradient(colors: [.blue, .purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask(
                Text(message)
                    .font(.body)
                    .fontWeight(.semibold)
            )
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}
#Preview {
    SettingsView()
        .environmentObject(CourseData())
        .environmentObject(Coordinator())
}
