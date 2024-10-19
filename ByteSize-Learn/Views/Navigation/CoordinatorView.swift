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
    @StateObject private var userAuth: UserAuthModel =  UserAuthModel()
    
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .Home) // Sets home as root
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
        .environmentObject(userAuth)
        .onChange(of: userAuth.isLoggedIn) {
            if !userAuth.isLoggedIn {
                print("Not Logged In")
                coordinator.push(.Login)
            } else {
                print("Logged In")
                coordinator.push(.Onboarding)
            }
        }
        /*.onChange(of: userAuth.newUser) {
            print(userAuth.newUser)
            print("Empty: ")
            print(coordinator.path.isEmpty)
            if !userAuth.newUser {
                coordinator.popToRoot()
            }
        }*/

        
        
        
    }
}

#Preview {
    CoordinatorView()
}
