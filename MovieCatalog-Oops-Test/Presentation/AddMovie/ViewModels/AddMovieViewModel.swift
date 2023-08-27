//
//  AddMovieViewModel.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation

//View Model for AddMovie screen
class AddMovieViewModel: ObservableObject {
    // MARK: - Properties
    let networkService = NetworkService()
    let realmService = RealmService.shared
    @Published var movies: [MovieCardCellModel] = []
    @Published var isError: Bool = false
    @Published var errorMessage: String?
    
    // MARK: -  Deinitialization
    deinit {
        // Invalidate the Realm notification token to prevent memory leaks
        realmService.notificationToken?.invalidate()
    }
    
    // MARK: - Functions
    // Fetches movie data from a network source
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
                    
                    // Create a new Movie object with the fetched data
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
                self.errorMessage = "Failed to get movies: \(error)"
                self.isError = true
            }
        }
    }
    
    func resetErrorStatus() {
        self.errorMessage = nil
        self.isError = false
    }
    
    func addMovieData(movie: Movie) {
        realmService.saveMovie(movie: movie)
    }
    
    func removeMovieData(movie: Movie) {
        realmService.deleteMovie(movie: movie)
    }
}

