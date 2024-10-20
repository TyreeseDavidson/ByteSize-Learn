//
//  Coordinator.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

extension Course {
    var id: String { name }
}

enum Page: Hashable, Codable, Identifiable {
    case onboarding, home, settings, about, learning(course: Course)

    var id: String {
        switch self {
        case .onboarding:
            return "onboarding"
        case .home:
            return "home"
        case .settings:
            return "settings"
        case .about:
            return "about"
        case .learning(let course):
            return "learning_\(course.name)"
        }
    }
}

enum Sheet: String, Identifiable {
    case exampleSheet // Add later if needed

    var id: String {
        self.rawValue
    }
}

enum FullScreenCover: String, Identifiable {
    case exampleFullScreen // Add later if needed

    var id: String {
        self.rawValue
    }
}

class Coordinator: ObservableObject {

    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?

    func push(_ page: Page) {
        path.append(page)
    }

    func present(sheet: Sheet) {
        self.sheet = sheet
    }

    func present(fullScreenCover: FullScreenCover) {
        self.fullScreenCover = fullScreenCover
    }

    func pop() {
        if !path.isEmpty {
            path.removeLast()
        }
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func navigateToHome() {
            DispatchQueue.main.async {
                self.path = NavigationPath()
                self.path.append(Page.home)
            }
    }
    
    func dismissSheet() {
        self.sheet = nil
    }

    func dismissFullScreenCover() {
        self.fullScreenCover = nil
    }

    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .onboarding:
            OnboardingView()
        case .home:
            HomePageView()
        case .learning(let course):
            LearningView(course: course)
        case .settings:
            SettingsView()
        case .about:
            AboutView()
        }
    }

    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .exampleSheet:
            // ExampleSheetView()
            // Wrap in a navigation stack if you want to see the navigation title
            NavigationStack {
                // ExampleSheetView()
            }
        }
    }

    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .exampleFullScreen:
            // ExampleFullScreenView()
            // Wrap in a navigation stack if you want to see the navigation title
            NavigationStack {
                // ExampleFullScreenView()
            }
        }
    }
}
