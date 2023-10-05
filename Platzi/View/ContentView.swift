//
//  ContentView.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import SwiftUI
import Combine

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    @StateObject private var imageLoader = ImageLoader()

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.movies) { movie in
                        MovieRow(movie: movie, imageLoader: imageLoader)
                            .padding(.leading)
                            .background(
                                LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.2)]), startPoint: .topLeading, endPoint: .bottom)
                                    .cornerRadius(15)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            )
                            .padding(.top, 10)
                    }
                }
            }
            .navigationBarTitle("Películas", displayMode: .large)
            .onAppear {
                viewModel.fetchMovies(ofType: .popular)
            }
        }
    }
}

struct MovieRow: View {
    var movie: Movie
    @StateObject var imageLoader: ImageLoader
    @State private var uiImage: UIImage?

    var body: some View {
        HStack(spacing: 20) {
            // Image
            if let image = uiImage {
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
        .onAppear {
            Task {
                let posterPath = movie.posterPath
                uiImage = await imageLoader.loadImage(from: "https://image.tmdb.org/t/p/w200\(posterPath)")
            }
        }
    }
}

@available(iOS 15.0, *)
struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
