import SwiftUI

struct AddCourseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""

    var onAdd: (Course) -> Void

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Header with plain black text
                Text("Add Course")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .frame(height: 100)

                // Course Name Field
                VStack(alignment: .leading) {
                    Text("Course Name")
                        .foregroundColor(.black) // Plain black text
                        .padding(.leading, 8)

                    TextField("", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                }

                // Course Description Field
                VStack(alignment: .leading) {
                    Text("Course Description")
                        .foregroundColor(.black) // Plain black text
                        .padding(.leading, 8)
                        .padding(.top, 4)

                    TextEditor(text: $description)
                        .frame(height: 150)
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(8)
                }

                Spacer()

                // Action Button
                HStack {
                    Button("Add") {
                        let newCourse = Course(name: name, description: description)
                        onAdd(newCourse)
                        dismiss()
                    }
                    .font(.headline)
                    .disabled(name.isEmpty || description.isEmpty)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.blue, .purple]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.3)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
    }
}
