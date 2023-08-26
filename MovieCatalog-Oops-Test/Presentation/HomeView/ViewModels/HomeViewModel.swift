//
//  HomeViewModel.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/24/23.
//

import Foundation
import Combine

//View Model for Home screen
class HomeViewModel: ObservableObject  {
    // MARK: - Properties
    let realmService = RealmService.shared
    private var cancellables = Set<AnyCancellable>()
    @Published var movies: [Movie] = []
    
    // MARK: -  Initialization
    init() {
        loadDataFromRealm()
        
        // Set up a Combine subscription to react to Realm updates
        realmService.$movieUpdate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadDataFromRealm()
            }
            .store(in: &cancellables)
    }
    // MARK: -  Deinitialization
    deinit {
        // Invalidate the Realm notification token to prevent memory leaks
        realmService.notificationToken?.invalidate()
    }

    // MARK: - Functions
    
    // Load movie data from Realm
    func loadDataFromRealm() {
        movies = realmService.getAllMovies()
    }
    
    // Generate an array of MovieCellModel for SwiftUI
    func getMovieCellModel() -> [MovieCellModel] {
        movies.map { MovieCellModel(id: $0.id, urlPoster: $0.urlPoster, title: $0.title) }
    }
    
    func deleteMovie(id: Int) {
        if let movie = movies.first(where: { $0.id == id }) {
            realmService.deleteMovie(movie: movie)
        }
    }
}
