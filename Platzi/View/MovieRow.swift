//
//  MovieRow.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 05/10/23.
//

import SwiftUI

struct MovieRow: View {
    var movie: Movie

    var body: some View {
        HStack(spacing: 20) {
            // Image
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w200\(movie.posterPath ?? "")")) { phase in
                switch phase {
                case .empty:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 150)
                case .success(let image):
                    image.resizable()
                        .frame(width: 100, height: 150)
                        .cornerRadius(10)
                case .failure:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.red.opacity(0.5))
                        .frame(width: 100, height: 150)
                        .overlay(
                            Text("Error")
                                .foregroundColor(.white)
                        )
                @unknown default:
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 100, height: 150)
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
    }
}

struct MovieRow_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(
            adult: false,
            backdropPath: "/test.jpg",
            genreIDS: [],
            id: 12345,
            originalTitle: "Pelicula",
            overview: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.",
            popularity: 5.5,
            posterPath: "/test.jpg",
            releaseDate: "2022-01-01",
            title: "Pelicula",
            video: false,
            voteAverage: 5.5,
            voteCount: 100
        )
        
        return MovieRow(movie: sampleMovie)
    }
}
