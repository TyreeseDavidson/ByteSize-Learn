//
//  OnboardingView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct OnboardingView: View {
    // Sudo Code:
    // If user accepts notifications:
    //     change send notifcations to true
    //
    // When user accepts terms:
    //     If first time login push to onboarding
    //     Else pop to home
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var userAuth: UserAuthModel
    
    var body: some View {
        VStack{
            Text("Onboarding")
        }
        .padding(.bottom, 10)
        Button("Pop to Root"){
            coordinator.popToRoot()
        }
        .navigationTitle("OnboardingView")
        .toolbar(.hidden) // Hides the arrow navigation in the top left corner
    }
}

#Preview {
    OnboardingView()
}

