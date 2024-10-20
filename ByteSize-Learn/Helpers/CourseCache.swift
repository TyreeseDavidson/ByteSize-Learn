//
//  CourseCache.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import Foundation

class CourseCache {
    static let shared = CourseCache()
    private let coursesKey = "availableCourses"

    private init() {}

    func saveCourses(_ courses: [Course]) {
        if let encoded = try? JSONEncoder().encode(courses) {
            UserDefaults.standard.set(encoded, forKey: coursesKey)
        }
    }

    func loadCourses() -> [Course] {
        guard let data = UserDefaults.standard.data(forKey: coursesKey),
              let courses = try? JSONDecoder().decode([Course].self, from: data) else {
            return []  // Return an empty array if no courses are found
        }
        return courses
    }
}

