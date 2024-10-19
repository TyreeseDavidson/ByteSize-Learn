//
//  SettingsView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct SettingsView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack{
            Text("Settings")
        }
        .padding(.bottom, 10)
        Button("Push About") {
            coordinator.push(.About)
        }
        .padding(.bottom, 10)
        Button("Pop") {
            coordinator.pop()
        }
        .navigationTitle("Settings")
    }
    
}
    

#Preview {
    SettingsView()
}
