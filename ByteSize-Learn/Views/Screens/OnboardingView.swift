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
    @State private var acceptedNotifications = false
    @State private var acceptedTerms = false
    @State private var isAddingCourse = false
    @State private var showErrorAlert = false
    @State private var errorMessage = ""
    
    // Total number of onboarding steps
    private let totalTabs = 4
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                welcomeView
                    .tag(0)
                
                infoView
                    .tag(1)
                
                notificationView
                    .tag(2)
                
                courseSelectionView
                    .tag(3)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            .animation(.easeInOut, value: selectedTab)
            
//            // Navigation Controls
//            HStack {
//                if selectedTab > 0 {
//                    Button(action: {
//                        withAnimation {
//                            selectedTab -= 1
//                        }
//                    }) {
//                        Text("Back")
//                            .fontWeight(.semibold)
//                            .padding()
//                            .frame(maxWidth: .infinity)
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(10)
//                    }
//                } else {
//                    // Placeholder to align the "Next" button
//                    Spacer()
//                        .frame(maxWidth: .infinity)
//                }
//                
//                Spacer()
//                
//                Button(action: nextStep) {
//                    Text(selectedTab == totalTabs - 1 ? "Finish" : "Next")
//                        .fontWeight(.semibold)
//                        .padding()
//                        .frame(maxWidth: .infinity)
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//            .padding([.horizontal, .bottom])
        }
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Error"),
                  message: Text(errorMessage),
                  dismissButton: .default(Text("OK")))
        }
        .navigationBarTitle("Welcome to ByteSize-Learn", displayMode: .inline)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.purple.opacity(0.3), Color.blue.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .edgesIgnoringSafeArea(.all)
        )
    }
    
    // MARK: - Tab Views
    
    var welcomeView: some View {
        VStack {
            Spacer()
            
            // Welcome Text or App Title
            TypingTextView(text: "ByteSize Learning")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // Description or tagline
            Text("Replace doom scrolling with micro-learning!")
                .font(.headline)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Spacer()
        }
        .tag(0)
    }
    
    var infoView: some View {
        VStack(alignment: .leading, spacing: 20) {
            TypingTextView(text: "Features")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 10)
    
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "book.fill")
                    .foregroundColor(.green)
                Text("• Curated Courses")
                    .font(.title3)
            }
    
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "flashlight.on.fill")
                    .foregroundColor(.orange)
                Text("• Interactive Flashcards")
                    .font(.title3)
            }
    
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "chart.bar.fill")
                    .foregroundColor(.purple)
                Text("• Progress Tracking")
                    .font(.title3)
            }
    
            Spacer()
        }
        .padding()
        .tag(1)
    }
    
    var notificationView: some View {
        VStack(spacing: 20) {
            Text("Enable Notifications")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Receive timely reminders for your learning sessions.")
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Toggle("Allow Notifications", isOn: $acceptedNotifications)
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Spacer()
        }
        .padding()
        .tag(2)
    }
    
    var courseSelectionView: some View {
        VStack(spacing: 20) {
            TypingTextView(text: "Get Started")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            Text("Let's set up your first courses to begin your learning journey.")
                .font(.title3)
                .multilineTextAlignment(.center)
                .padding()
            
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
            
//            List {
//                Section(header: Text("Manage Courses")) {
//                    ForEach(courseData.courses, id: \.id) { course in
//                        VStack(alignment: .leading) {
//                            Text(course.name)
//                                .font(.headline)
//                            Text(course.description)
//                                .font(.subheadline)
//                                .foregroundColor(.gray)
//                        }
//                    }
//                    .onDelete(perform: courseData.removeCourse)
//
//                    Button(action: {
//                        isAddingCourse = true
//                    }) {
//                        HStack {
//                            Image(systemName: "plus.circle.fill")
//                            Text("Add New Course")
//                        }
//                    }
//                }
//            }

            
            Button(action: {
                isAddingCourse = true
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Your First Course")
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .padding(.horizontal)
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
            
            Spacer()
            
            Button(action: {
                if courseData.courses.isEmpty {
                    errorMessage = "Please add at least one course to proceed."
                    showErrorAlert = true
                } else {
                    coordinator.navigateToHome()
                }
            }) {
                Text("Continue")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(courseData.courses.isEmpty ? Color.gray : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .disabled(courseData.courses.isEmpty)
        }
        .padding()
        .tag(3)
    }
    
    // MARK: - Navigation Functions
    
    func nextStep() {
        if selectedTab < totalTabs - 1 {
            withAnimation {
                selectedTab += 1
            }
        } else {
            finishOnboarding()
        }
    }
    
    func finishOnboarding() {
        // Save onboarding preferences if needed
        // UserDefaults.standard.set(acceptedNotifications, forKey: "acceptedNotifications")
        // UserDefaults.standard.set(false, forKey: "isFirstTimeLogin")
        coordinator.navigateToHome()
    }
    
    // MARK: - Optional: Fetch Cards for Course
    
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

// MARK: - Preview

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
            .environmentObject(CourseData())
            .environmentObject(Coordinator())
    }
}
