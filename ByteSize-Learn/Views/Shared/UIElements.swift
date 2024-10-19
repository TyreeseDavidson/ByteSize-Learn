//
//  UIElements.swift
//  ByteSize-Learn
//
//  Created by Eli Peter on 10/19/24.
//

import SwiftUI
import Combine

struct AsyncImage<Placeholder: View>: View {
    @State private var data: Data?
    let url: URL
    let placeholder: Placeholder
    let image: (Data) -> Image

    var body: some View {
        ZStack {
            if let data = data, let _ = UIImage(data: data) {
                self.image(data)
                    .resizable()
                    .mask{
                        Circle()
                    }
            } else {
                placeholder
            }
        }
        .onAppear(perform: loadImage)
    }

    private func loadImage() {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }.resume()
    }
}

struct DropdownButton: View {
    var title: String
    var icon: String?
    var url: String?
    var action: () -> Void

    var body: some View {
        HStack {
            Button(action: action) {
                if let icon = icon {
                    Image(systemName: icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                } else if let urlString = url, let url = URL(string: urlString) {
                    AsyncImage(
                        url: url,
                        placeholder: Text("Loading..."),
                        image: { Image(uiImage: UIImage(data: $0)!) }
                    )
                    .frame(width: 50, height: 50)
                }
            }
            .buttonStyle(RoundButtonStyle())
            
            Text(title)
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading) // Ensure HStack takes full width for alignment
    }
}


struct RoundButtonStyle: ButtonStyle {
    var foregroundColor: Color
    var backgroundColor: Color

    init(foregroundColor: Color = .white, backgroundColor: Color = .teal) {
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: 50, height: 50)
            .background(backgroundColor)
            .foregroundStyle(foregroundColor)
            .clipShape(Circle())
            // .shadow(radius: 10)
    }
}
