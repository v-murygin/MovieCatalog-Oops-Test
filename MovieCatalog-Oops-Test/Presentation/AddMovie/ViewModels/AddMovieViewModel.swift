//
//  AddMovieViewModel.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation

class AddMovieViewModel: ObservableObject {
    let networkService = NetworkService()
    let realmService = RealmService.shared
    
    @Published var movies: [MovieCardCellModel] = []
    
    deinit {
        realmService.notificationToken?.invalidate()
    }

    func fetchData() {
        Task {
            do {
                let moviesNetwork = try await networkService.getPopularMoviesTMDB()
                var newMovies: [Movie] = []
                for movie in moviesNetwork {
                    let baseImageURL = "https://image.tmdb.org/t/p/w500"
                    let urlPoster = URL(string: baseImageURL + (movie.posterPath ?? ""))
                    let urlBackdrop = URL(string: baseImageURL + (movie.backdropPath ?? ""))
                    let urllogo =  try? await  NetworkService().getMoviesLogoTMDB(forMovieId: movie.id)
                    
                    let newMovie = Movie(id: movie.id,
                                         title: movie.title,
                                         urlPoster: urlPoster,
                                         urlBackdrop: urlBackdrop,
                                         urllogo: urllogo,
                                         descriptionMovie: movie.overview,
                                         showMovieQuality: Bool.random())
                    
                    newMovies.append(newMovie)
                }
                DispatchQueue.main.async { [newMovies] in
                    self.movies = newMovies.map { MovieCardCellModel(movie: $0, isTapped: false) }
                }
            } catch {
                print("Failed to get movies: \(error)")
            }
        }
    }
    
    func addMovieData(movie: Movie) {
        realmService.saveMovie(movie: movie)
    }
    
    func removeMovieData(movie: Movie) {
        realmService.deleteMovie(movie: movie)
    }
}

