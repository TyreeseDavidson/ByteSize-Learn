//
//  ByteSize_LearnApp.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI
import Amplify
import AWSCognitoAuthPlugin

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      func configureAmplify() {
          do {
              try Amplify.add(plugin: AWSCognitoAuthPlugin())
              try Amplify.configure()
              print("Amplify configured with Auth plugin")
          } catch {
              print("Failed to initialize Amplify with \(error)")
          }
      }
    return true
  }
}

@main
struct ByteSize_LearnApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
