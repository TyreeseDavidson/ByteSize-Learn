//
//  AboutView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct AboutView: View {
    
    @EnvironmentObject private var coordinator: Coordinator
    
    var body: some View {
        VStack{
            Text("About")
        }
        .padding(.bottom, 10)
        Button("Pop to Root") {
            coordinator.popToRoot()
        }
        .navigationTitle("About")
    }
}

#Preview {
    AboutView()
}
