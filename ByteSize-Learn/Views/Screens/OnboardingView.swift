//
//  OnboardingView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//
import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var currentStep = 0
    @State private var acceptedNotifications = false
    @State private var acceptedTerms = false
    @State private var selectedCourses: Set<String> = []
    @State private var customCourse = ""
    @State private var availableCourses = ["System Software", "Data Structures and Algorithms", "Intro to Java Programming", "Discrete Math"]
    
    var body: some View {
        VStack {
            Spacer()
            
            switch currentStep {
            case 0:
                welcomeView
            case 1:
                notificationView
            case 2:
                termsView
            case 3:
                courseSelectionView
            default:
                Text("Onboarding Complete!")
            }
            
            Spacer()
            
            HStack {
                if currentStep > 0 {
                    Button("Back") {
                        currentStep -= 1
                    }
                }
                
                Spacer()
                
                Button(action: nextStep) {
                    Text(currentStep == 3 ? "Finish" : "Next")
                }
            }
            .padding()
        }
        .navigationBarTitle("Welcome to ByteSize-Learn")
        .navigationBarHidden(true)
    }
    
    var welcomeView: some View {
        VStack {
            Text("Welcome to ByteSize-Learn!")
                .font(.largeTitle)
            Text("Let's get you set up for efficient microlearning.")
                .multilineTextAlignment(.center)
        }
    }
    
    var notificationView: some View {
        VStack {
            Text("Enable Notifications")
                .font(.title)
            Text("Receive timely reminders for your learning sessions.")
            Toggle("Allow Notifications", isOn: $acceptedNotifications)
                .padding()
        }
    }
    
    var termsView: some View {
        VStack {
            Text("Terms and Conditions")
                .font(.title)
            Text("Please read and accept our terms of service.")
            Toggle("I accept the terms and conditions", isOn: $acceptedTerms)
                .padding()
        }
    }
    
    var courseSelectionView: some View {
            VStack {
                Text("Select Your Courses")
                    .font(.title)
                Text("Choose the courses you're enrolled in:")
                
                List {
                    ForEach(availableCourses, id: \.self) { course in
                        Toggle(course, isOn: Binding(
                            get: { selectedCourses.contains(course) },
                            set: { isSelected in
                                if isSelected {
                                    selectedCourses.insert(course)
                                } else {
                                    selectedCourses.remove(course)
                                }
                            }
                        ))
                    }
                    .onDelete(perform: deleteCourse)
                    
                    HStack {
                        TextField("Enter a custom course", text: $customCourse)
                        Button(action: addCustomCourse) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }
        }
        
        func addCustomCourse() {
            let trimmedCourse = customCourse.trimmingCharacters(in: .whitespacesAndNewlines)
            if !trimmedCourse.isEmpty && !availableCourses.contains(trimmedCourse) {
                availableCourses.append(trimmedCourse)
                selectedCourses.insert(trimmedCourse)
                customCourse = ""
            }
        }
        func nextStep() {
            if currentStep < 3 {
                currentStep += 1
            } else {
                finishOnboarding()
            }
        }
        
        func deleteCourse(at offsets: IndexSet) {
            let coursesToRemove = offsets.map { availableCourses[$0] }
            availableCourses.remove(atOffsets: offsets)
            selectedCourses.subtract(coursesToRemove)
        }
        
        func finishOnboarding() {
            UserDefaults.standard.set(acceptedNotifications, forKey: "acceptedNotifications")
            UserDefaults.standard.set(Array(selectedCourses), forKey: "selectedCourses")
            UserDefaults.standard.set(availableCourses, forKey: "availableCourses")
            UserDefaults.standard.set(false, forKey: "isFirstTimeLogin")
            coordinator.navigateToHome()
        }
    }
