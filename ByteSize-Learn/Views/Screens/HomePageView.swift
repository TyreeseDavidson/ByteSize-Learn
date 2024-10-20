//
//  HomePageView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct HomePageView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var courses: [Course] = []
    @State private var showDropdown = false

    var body: some View {
        ZStack {
            VStack {
                Text("What course will you be learning from today?")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding(.top, 60)
                    .padding(.horizontal, 16)

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    ForEach(courses, id: \.id) { course in
                        Button(action: {
                            print("\(course.name) selected")
                            print("\(course.cards)")
                            coordinator.push(.learning(course: course))
                        }) {
                            Text(course.name)
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

            dropdownMenu
        }
        .onAppear {
            loadCourses()
        }
    }

    private var dropdownMenu: some View {
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

    private func loadCourses() {
        courses = CourseCache.shared.loadCourses()
    }
}
