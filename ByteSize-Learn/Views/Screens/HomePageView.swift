//
//  HomePageView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//
import SwiftUI

struct HomePageView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var showDropdown = false
    @State private var courses: [String] = []
    
    var body: some View {
        ZStack {
            VStack {
                Text("What course will you be learning from today?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60) // Increase top padding to make room for the dropdown
                    .padding(.horizontal, 16)
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(courses, id: \.self) { course in
                        Button(action: {
                            print("\(course) selected")
                            let sampleCourse = Course(
                                name: course,
                                description: "Learn the fundamentals of this course.")
                            coordinator.push(.learning(course: sampleCourse))
                        }) {
                            Text(course)
                                .multilineTextAlignment(.center)
                                .padding()
                                .frame(maxWidth: .infinity, minHeight: 120)
                                .background(Color.white)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer()
            }
            
            // Dropdown menu
            VStack {
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        showDropdown.toggle()
                                    }
                                }) {
                                    Image(systemName: showDropdown ? "xmark" : "line.3.horizontal")
                                        .rotationEffect(.degrees(showDropdown ? 90 : 0))
                                }
                                .buttonStyle(RoundButtonStyle(foregroundColor: .black, backgroundColor: .white))
                                
                                Spacer()
                            }
                            .padding(.top, 10)
                            .padding(.leading, 16)
                            
                            if showDropdown {
                                VStack(alignment: .leading, spacing: 10) {
                                    DropdownButton(title: "About", icon: "questionmark.circle.fill") {
                                        showDropdown.toggle()
                                        coordinator.push(.about)
                                    }
                                    DropdownButton(title: "Settings", icon: "gear") {
                                        showDropdown.toggle()
                                        coordinator.push(.settings)
                                    }
                                }
                                .padding(.top, 10)
                                .padding(.leading, 16)
                                .transition(.move(edge: .top))
                            }
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .background(
                            Group {
                                if showDropdown {
                                    Color.black.opacity(0.8)
                                        .ignoresSafeArea()
                                        .onTapGesture {
                                            withAnimation {
                                                showDropdown = false
                                            }
                                        }
                                } else {
                                    Color.clear
                                }
                            }
                        )
                    }
                    .onAppear(perform: loadCourses)
                }
    
    private func loadCourses() {
        if let savedCourses = UserDefaults.standard.stringArray(forKey: "availableCourses") {
            courses = savedCourses
        } else {
            // Fallback to default courses if none are saved
            courses = [
                "Data Structures and Algorithms",
                "System Software",
                "Intro to Java Programming",
                "Discrete Math"
            ]
        }
    }
}

#Preview {
    HomePageView().environmentObject(Coordinator())
}
