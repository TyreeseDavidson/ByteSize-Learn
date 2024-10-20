//
//  CoordinatorView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct CoordinatorView: View {
    @StateObject private var coordinator = Coordinator()
    @AppStorage("isFirstTimeLogin") private var isFirstTimeLogin = true
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if isFirstTimeLogin {
                    coordinator.build(page: .onboarding)
                } else {
                    coordinator.build(page: .home)
                }
            }
            .navigationDestination(for: Page.self) { page in
                coordinator.build(page: page)
            }
        }
        .environmentObject(coordinator)
    }
}
