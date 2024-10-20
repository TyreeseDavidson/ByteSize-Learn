//
//  AddCourseView.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI

struct AddCourseView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name = ""
    @State private var description = ""

    var onAdd: (Course) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Course Information")) {
                    TextField("Course Name", text: $name)
                    TextField("Course Description", text: $description)
                }
            }
            .navigationTitle("Add Course")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        let newCourse = Course(name: name, description: description)
                        onAdd(newCourse)
                        dismiss()
                    }
                    .disabled(name.isEmpty || description.isEmpty)
                }
            }
        }
    }
}

