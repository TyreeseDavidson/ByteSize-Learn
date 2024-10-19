//
//  HomePageView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct HomePageView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var userAuth: UserAuthModel
    @State private var showDropdown = false
    
    
    var body: some View {
        VStack{
            // HOMESCREEN CODE HERE
            VStack {
                            Text("Home Page")
                                .font(.headline)
                                .padding(.bottom, 10)
                            
                            Button("Push Login Page") {
                                coordinator.push(.Login)
                            }
                            .padding(.bottom, 10)
                            
//                            Button("Present Example Sheet") {
//                                coordinator.present(sheet: .ExampleSheet)
//                            }
//                            Button("Present Example FullScreenCover") {
//                                coordinator.present(fullScreenCover: .ExampleFullScreen)
//                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1)) // Blue background only for this portion
                        .cornerRadius(20)
                        
                        Spacer()
            
        }
        .overlay(
            ZStack {
                // Semi-transparent overlay
                if showDropdown {
                    Color.black.opacity(0.8)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                showDropdown = false
                            }
                        }
                }
                
                // Main button and dropdown menu aligned to the top leading
                VStack(alignment: .leading, spacing: 10) {
                    Button(action: {
                        withAnimation {
                            showDropdown.toggle()
                        }
                    }) {
                        Image(systemName: showDropdown ? "xmark" : "line.3.horizontal")
                            .rotationEffect(.degrees(showDropdown ? 90 : 0))
                    }
                    .buttonStyle(RoundButtonStyle(foregroundColor: .black, backgroundColor: .white))
                    
                    if showDropdown {
                        // Dropdown buttons
                        DropdownButton(title: "Account", url:  userAuth.profilePicUrl) {
                            showDropdown.toggle()
                            coordinator.push(.Account)
                        }
                        DropdownButton(title: "About", icon: "questionmark.circle.fill") {
                            showDropdown.toggle()
                            coordinator.push(.About)
                        }
                        DropdownButton(title: "Privacy & Terms", icon: "lock.shield.fill") {
                            showDropdown.toggle()
                            coordinator.push(.PrivacyAndTerms)
                        }
                    }
                }
                .padding(.top, 10) // Adjust this value as needed
                .padding(.leading, 16) // Adjust this value as needed
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading) // Ensure the VStack aligns to the top leading
            }
        )
    }
}


#Preview {
    HomePageView()
}

