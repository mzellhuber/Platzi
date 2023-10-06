//
//  MovieRow.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 05/10/23.
//

import SwiftUI
import RealmSwift

struct MovieRow: View {
    var movie: Movie
    @State private var loadedImage: UIImage?
    private let imageLoader = ImageLoader()

    var body: some View {
        HStack(spacing: 20) {
            // Image
            if let image = loadedImage {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 100, height: 150)
                    .cornerRadius(10)
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 100, height: 150)
            }
            
            // Movie Details
            VStack(alignment: .leading, spacing: 10) {
                Text(movie.title)
                    .font(.headline)
                    .padding()
                Text(movie.overview)
                    .font(.subheadline)
                    .truncationMode(.tail)
                    .padding()
            }
            .padding(.trailing, 10)
        }
        .task {
            do {
                loadedImage = try await imageLoader.loadImage(from: "https://image.tmdb.org/t/p/w200\(movie.posterPath )")
                
                if let data = loadedImage?.pngData() {
                    guard let realm = try? await Realm() else { return }
                    try? realm.write {
                        movie.imageData = data
                    }
                }
            } catch {
                print("Failed to load image: \(error)")
            }
        }
    }
}
