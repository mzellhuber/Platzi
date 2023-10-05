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
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.2), Color.blue.opacity(0.05)]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .center, spacing: 20) {
                    AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(viewModel.movie.posterPath ?? "")")) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .cornerRadius(15)
                                .shadow(radius: 10)
                                .frame(width: 220, height: 330)
                        default:
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 220, height: 330)
                        }
                    }
                    
                    Text(viewModel.movie.overview)
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .foregroundColor(.black)
                    
                    if viewModel.videoKey == nil {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.blue))
                            .scaleEffect(1.5)
                            .frame(width: 340, height: 200)
                            .background(Color.white.opacity(0.8))
                            .cornerRadius(15)
                            .shadow(radius: 5)
                    } else if let videoKey = viewModel.videoKey {
                        WebView(url: URL(string: "https://www.youtube.com/embed/\(videoKey)")!)
                            .cornerRadius(15)
                            .shadow(radius: 5)
                            .frame(width: 340, height: 200)
                    }
                }
                .padding(.top, 30)
            }
        }
        .navigationBarTitle(viewModel.movie.title, displayMode: .inline)
        .onAppear(perform: viewModel.fetchMovieVideo)
    }
}
