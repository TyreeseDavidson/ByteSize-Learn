//
//  Coordinator.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

enum Page: String, Identifiable {
    case Onboarding, Home, Settings, About
    
    var id: String {
        self.rawValue
    }
}

enum Sheet : String, Identifiable {
    case ExampleSheet // Add later if needed
    
    var id: String {
        self.rawValue
    }
}

enum FullScreenCover : String, Identifiable {
    case ExampleFullScreen // Add later if needed
    
    var id: String {
        self.rawValue
    }
}

class Coordinator: ObservableObject {
    
    @Published var path = NavigationPath()
    @Published var sheet: Sheet?
    @Published var fullScreenCover: FullScreenCover?
    
    func push(_ page: Page){
        path.append(page)
    }
    
    func present(sheet: Sheet){
        self.sheet = sheet
    }
    
    func present(fullScreenCover: FullScreenCover){
        self.fullScreenCover = fullScreenCover
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func dismissSheet(){
        self.sheet = nil;
    }
    
    func dismissFullScreenCover(){
        self.fullScreenCover = nil;
    }
    
    @ViewBuilder
    func build(page: Page) -> some View {
        switch page {
        case .Onboarding:
            OnboardingView()
        case .Home:
            HomePageView()
        case .Settings:
            SettingsView()
        case .About:
            AboutView()
            
        }
    }
    
    @ViewBuilder
    func build(sheet: Sheet) -> some View {
        switch sheet {
        case .ExampleSheet:
            // ExampleSheetView()
            
            // Wrap in a navigation stack if you want to see the navigation title
            NavigationStack {
                //ExampleSheetView()
            }
        }
    }
    
    @ViewBuilder
    func build(fullScreenCover: FullScreenCover) -> some View {
        switch fullScreenCover {
        case .ExampleFullScreen:
            // ExmpleFullScreenView()
            
            // Wrap in a navigation stack if you want to see the navigation title
            NavigationStack {
                //ExmpleFullScreenView()
            }
        }
    }
    
}

