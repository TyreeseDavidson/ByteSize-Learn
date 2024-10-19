//
//  CoordinatorView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct CoordinatorView: View {
    // No need to edit this
    
    @StateObject private var coordinator = Coordinator()
    
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .home) // Sets home as root
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreenCover in
                    coordinator.build(fullScreenCover: fullScreenCover)
                }
        }
        .environmentObject(coordinator)
    
    }
}

#Preview {
    CoordinatorView()
}
