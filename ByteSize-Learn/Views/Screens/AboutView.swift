import SwiftUI

struct AboutView: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header Section
                Text("About ByteSize Learn")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 8)

                // Intro Section
                Text("""
                Welcome to ByteSize-Learn, a microlearning app developed during the Lehigh University CSBA 2024 Hackathon!
                """)
                .multilineTextAlignment(.leading)
                .font(.body)
                .foregroundColor(.secondary)

                // Project Overview
                SectionHeader(title: "Project Overview")
                Text("""
                ByteSize-Learn is designed to help college students efficiently learn and practice course material through quick, targeted questions.
                Our app provides practice problems tailored to the specific courses a student selects, making learning more manageable in bite-sized sessions.
                """)

                // Features
                SectionHeader(title: "Features")
                FeatureList(features: [
                    "Course-Specific Practice",
                    "Quick Question Format",
                    "Instant Feedback"
                ])

                // Why ByteSize-Learn?
                SectionHeader(title: "Why ByteSize-Learn?")
                Text("""
                In today's fast-paced academic environment, students often need quick, focused ways to practice and review key concepts without the time commitment of full-length problem sets.
                ByteSize-Learn aims to fill that gap, offering an effective and engaging solution for microlearning in higher education.
                """)

                Spacer(minLength: 20)
            }
            .padding(24)
        }
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .navigationBarTitle("About", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
    }

    // Back Button
    private var backButton: some View {
        Button(action: {
            coordinator.pop()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}

// Section Header View Modifier
struct SectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .padding(.top, 16)
    }
}

// Feature List View
struct FeatureList: View {
    let features: [String]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ForEach(features, id: \.self) { feature in
                HStack(alignment: .top) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .frame(width: 24)
                    Text(feature)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
        }
    }
}

#Preview {
    AboutView()
        .environmentObject(Coordinator())
}
