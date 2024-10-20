//
//  SettingsView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @State private var courses: [String] = []
    @State private var newCourse: String = ""
    
    var body: some View {
        VStack {
            List {
                Section(header: Text("Manage Courses")) {
                    ForEach(courses, id: \.self) { course in
                        Text(course)
                    }
                    .onDelete(perform: deleteCourse)
                    
                    HStack {
                        TextField("Add new course", text: $newCourse)
                        Button(action: addCourse) {
                            Image(systemName: "plus.circle.fill")
                        }
                    }
                }
            }
            
            Button("Save Changes") {
                saveCourses()
                coordinator.navigateToHome()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .navigationBarTitle("Settings", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            coordinator.navigateToHome()
        }) {
            Image(systemName: "chevron.left")
            Text("Back")
        })
        .onAppear(perform: loadCourses)
    }
    
    private func loadCourses() {
        if let savedCourses = UserDefaults.standard.stringArray(forKey: "availableCourses") {
            courses = savedCourses
        }
    }
    
    private func saveCourses() {
        UserDefaults.standard.set(courses, forKey: "availableCourses")
    }
    
    private func addCourse() {
        if !newCourse.isEmpty && !courses.contains(newCourse) {
            courses.append(newCourse)
            newCourse = ""
        }
    }
    
    private func deleteCourse(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
    }
}
