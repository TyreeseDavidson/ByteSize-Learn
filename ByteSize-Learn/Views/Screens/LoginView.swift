//
//  LoginView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI
import Amplify
import AuthenticationServices

struct LoginView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var userAuth: UserAuthModel

    var body: some View {
        VStack {
            Image("foodreal-logo-transparent-png")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 55)
        }
        .padding(.bottom, 10)
        
        // AWS COGNITO SIGN-IN BUTTON
        Button(action: {
            userAuth.signIn()
        }) {
            HStack {
                ZStack {
                    Circle()
                        .foregroundColor(.white)
                        .frame(width: 45, height: 45)
                    Image("google")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
                .padding(.leading, 2)
                Spacer()
                Text("Sign in with Google")
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.trailing, 20)
            }
            .frame(width: 240, height: 50)
            .background(Color.gray.opacity(0.15))
            .cornerRadius(25)
        }
        
        Button("Push Onboarding") {
            coordinator.push(.Onboarding)
        }
        .padding(.bottom, 10)
        
        Button("Pop to Root") {
            coordinator.popToRoot()
        }
        .navigationTitle("Login")
        .toolbar(.hidden) // Hides the navigation bar
    }
}


