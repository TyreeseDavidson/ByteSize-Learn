//
//  CourseData.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation
import Combine

class CourseData: ObservableObject {
    @Published var courses: [Course] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadCourses()
        
        // Optional: Automatically save courses when they change
        $courses
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main)  // Debounce to reduce save frequency
            .sink { [weak self] _ in
                self?.saveCourses()
            }
            .store(in: &cancellables)
    }
    
    /// Loads courses from the cache.
    func loadCourses() {
        courses = CourseCache.shared.loadCourses()
    }
    
    /// Saves courses to the cache.
    func saveCourses() {
        do {
            try CourseCache.shared.saveCourses(courses)
            print("Courses successfully saved.")
        } catch {
            print("Error saving courses: \(error)")
            // Optionally, handle the error (e.g., show an alert to the user)
        }
    }
    
    /// Adds a new course and saves the updated list.
    /// - Parameter course: The `Course` object to add.
    func addCourse(_ course: Course) {
        courses.append(course)
        saveCourses()
    }
    
    /// Removes courses at the specified offsets and saves the updated list.
    /// - Parameter offsets: The `IndexSet` indicating the positions to remove.
    func removeCourse(at offsets: IndexSet) {
        courses.remove(atOffsets: offsets)
        saveCourses()
    }
}
