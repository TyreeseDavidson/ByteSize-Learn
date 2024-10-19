//
//  AccountView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct AccountView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    @EnvironmentObject private var userAuth: UserAuthModel
    
    var body: some View {
        VStack{
            Text("Account")
        }
        .padding(.bottom, 10)
        
        Button("Pop to Root") {
            coordinator.popToRoot()
        }
        
        Button(action: {
            userAuth.signOut()
        }) {
            Text("Sign Out")
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .cornerRadius(10)
                .padding(.horizontal, 20) // Horizontal padding for the button
        }
        .navigationTitle("Account")
    }
}

#Preview {
    AccountView()
}

