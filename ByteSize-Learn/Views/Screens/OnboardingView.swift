//
//  OnboardingView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var courseData: CourseData
    @EnvironmentObject private var coordinator: Coordinator
    @State private var selectedTab = 0
    @State private var isAddingCourse = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    @State private var isLoading = false
    
    private let totalTabs = 3
    
    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    welcomeView.tag(0)
                    featuresView.tag(1)
                    courseSetupView.tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .animation(.easeInOut, value: selectedTab)
            }
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
//            .navigationBarTitle("Welcome to ByteSize Learning", displayMode: .inline)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).edgesIgnoringSafeArea(.all)
            )
            
            if isLoading {
                loadingOverlay
            }
        }
    }
    
    // MARK: - Onboarding Steps
    
    var welcomeView: some View {
        VStack {
            Spacer()
            
            TypingTextView(text: "ByteSize Learning")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Transform your scrolling into learning!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Text("Replace distractions with AI-powered microlearning tailored to your courses.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()
            
            Spacer()
        }
    }
    
    var featuresView: some View {
        VStack(alignment: .leading, spacing: 20) {
            TypingTextView(text: "What You’ll Love")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            featureItem(icon: "sparkles", title: "Engaging Flashcards")
            featureItem(icon: "brain.head.profile", title: "AI-Generated Course Questions")
            featureItem(icon: "arrow.up.right.circle", title: "Dynamic Difficulty Adjustment")
            featureItem(icon: "laptopcomputer", title: "Code Feedback for Coding Courses")
            featureItem(icon: "star", title: "Free with No Ads")
            
            Spacer()
        }
        .padding()
    }
    
    var courseSetupView: some View {
        VStack(spacing: 20) {
            TypingTextView(text: "Set Up Your Courses")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Select your current courses to begin learning.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
            List {
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
            }
            .scrollContentBackground(.hidden)
            
            addCourseButton
            
            Spacer()
            
            if !courseData.courses.isEmpty {
                continueButton
            }
        }
        .padding()
    }
    
    // MARK: - Helper Views
    
    func featureItem(icon: String, title: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            Text(title)
                .font(.title3)
        }
    }
    
    var addCourseButton: some View {
        Button(action: {
            isAddingCourse = true
        }) {
            HStack {
                Image(systemName: "plus.circle.fill")
                Text("Add Your First Courses")
                    .font(.headline)
                    .foregroundStyle(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.blue, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    ) // Apply gradient to text
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.white) // White background
            .cornerRadius(10)
//            .shadow(radius: 2) // Optional: Adds subtle shadow
        }
        .padding(.horizontal)
        .sheet(isPresented: $isAddingCourse) {
            AddCourseView { newCourse in
                addCourse(newCourse)
            }
        }
    }
    
    var continueButton: some View {
        Button(action: {
            coordinator.navigateToHome()
        }) {
            Text("Continue!")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.purple, Color.blue]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(10)
        }
        .padding(.horizontal)
        .padding(.bottom, 20)
    }
    
    var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)

            ProgressView("Loading...")
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .foregroundColor(.white)
                .padding()
                .background(Color.gray.opacity(0.7))
                .cornerRadius(10)
        }
    }

    
    // MARK: - Functions
    
    func addCourse(_ newCourse: Course) {
        Task {
            isLoading = true
            do {
                let fetchedCards = try await fetchCardsForCourse(course: newCourse)
                let updatedCourse = Course(
                    name: newCourse.name,
                    description: newCourse.description,
                    cards: fetchedCards
                )
                courseData.addCourse(updatedCourse)
            } catch {
                errorMessage = "Failed to fetch cards. Please try again."
                showErrorAlert = true
            }
            isLoading = false
        }
    }
    
    func fetchCardsForCourse(course: Course) async throws -> [CardModel] {
        var allFetchedCards: [CardModel] = []
        
        try await withThrowingTaskGroup(of: CardModel.self) { group in
            for _ in 1...5 {
                allFetchedCards.append (
                    try await APIService.shared.generateCard(
                        courseTitle: course.name,
                        courseDescription: course.description,
                        correctCount: 0,
                        incorrectCount: 0,
                        previousQuestions: allFetchedCards
                    )
                )
            }
        }
        
        return allFetchedCards
    }
}
