//
//  CardView.swift
//  Manage_App
//
//  Created by Pare on 11/6/2566 BE.
//

import SwiftUI

struct CardView: View {
    let imageURL: String
    let name: String

    var body: some View {
        VStack {
            // Asynchronously load and display the image from the URL
            AsyncImage(url: URL(string: imageURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(height: 200)
            .background(Color.gray)
            .cornerRadius(10)

            Text(name)
                .font(.headline)
                .padding()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding()
    }
}

struct ContentView: View {
    let imageURLs = [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg",
        "https://example.com/image3.jpg"
    ]

    let names = [
        "Image 1",
        "Image 2",
        "Image 3"
    ]

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(0..<imageURLs.count) { index in
                    CardView(imageURL: imageURLs[index], name: names[index])
                }
            }
            .padding()
        }
    }
}


struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView()
    }
}
