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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("About ByteSize-Learn")
                    .font(.largeTitle)
                    .padding(.bottom)
                
                Text("Welcome to ByteSize-Learn, a microlearning app developed during the Lehigh University CSBA 2024 Hackathon!")
                
                Text("Project Overview")
                    .font(.headline)
                Text("ByteSize-Learn is designed to help college students efficiently learn and practice course material through quick, targeted questions. Our app provides practice problems tailored to the specific courses a student selects, making learning more manageable in bite-sized sessions.")
                
                Text("Features")
                    .font(.headline)
                Text("• Course-Specific Practice\n• Quick Question Format\n• Instant Feedback")
                
                Text("Why ByteSize-Learn?")
                    .font(.headline)
                Text("In today's fast-paced academic environment, students often need quick, focused ways to practice and review key concepts without the time commitment of full-length problem sets. ByteSize-Learn aims to fill that gap, offering an effective and engaging solution for microlearning in higher education.")
                
                Spacer()
            }
            .padding()
        }
        .navigationBarTitle("About", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            coordinator.pop()
        }) {
            Image(systemName: "chevron.left")
            Text("Back")
        })
    }
}

#Preview {
    AboutView()
}
