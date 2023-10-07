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
            VStack {
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
                
                if let year = movie.releaseDate.split(separator: "-").first {
                    Text(String(year))
                        .font(.subheadline)
                }
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
            loadedImage = await imageLoader.loadImage(from: "https://image.tmdb.org/t/p/w200\(movie.posterPath )")
            
            if let data = loadedImage?.pngData() {
                realmQueue.async {
                    guard let realm = try? Realm() else { return }
                    try? realm.write {
                        movie.imageData = data
                    }
                }
            }
        }
    }
}
