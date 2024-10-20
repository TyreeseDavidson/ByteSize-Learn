//
//  ByteSize_LearnApp.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI


//class AppDelegate: NSObject, UIApplicationDelegate {
//  func application(_ application: UIApplication,
//                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
//      }
//    return true
//  }
//}

@main
struct ByteSize_LearnApp: App {
    @StateObject private var courseData = CourseData()

    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environmentObject(courseData)
        }
    }
}
