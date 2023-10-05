//
//  MovieDetailView.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 05/10/23.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MovieDetailsViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let videoKey = viewModel.videoKey {
                    WebView(url: URL(string: "https://www.youtube.com/embed/\(videoKey)")!)
                        .frame(height: 200)
                        .padding([.top, .horizontal])
                }

                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(viewModel.movie.posterPath ?? "")")) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(10)
                    default:
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 300, height: 450)
                    }
                }
                .padding([.horizontal, .bottom])

                Text(viewModel.movie.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                Text(viewModel.movie.overview)
                    .font(.body)
                    .padding(.horizontal)
            }
        }
        .navigationBarTitle(viewModel.movie.title, displayMode: .inline)
        .onAppear(perform: viewModel.fetchMovieVideo)
    }
}
