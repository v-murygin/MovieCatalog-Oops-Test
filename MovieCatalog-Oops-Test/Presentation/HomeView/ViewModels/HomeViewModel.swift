//
//  HomeViewModel.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/24/23.
//

import Foundation
import Combine
import SwiftUI

//View Model for Home screen
class HomeViewModel: ObservableObject  {
    // MARK: - Properties
    let realmService = RealmService.shared
    private var cancellables = Set<AnyCancellable>()
    @Published var movies: [Movie] = []
    @AppStorage("wasLaunchedBefore") var wasLaunchedBefore: Bool = false
    
    // MARK: -  Initialization
    init() {
        //Checking for “first run”
        if !wasLaunchedBefore {
            addDataFortheFirstRun()
            wasLaunchedBefore = true
        }
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
  
    //Display template of saved movies
    func addDataFortheFirstRun() {
        let mockMovie = [Movie(id: 724209, title: "Heart of Stone",
                               urlPoster: URL(string: "https://image.tmdb.org/t/p/w500/vB8o2p4ETnrfiWEgVxHmHWP9yRl.jpg"),
                               urlBackdrop: URL(string: "https://image.tmdb.org/t/p/w500/nYDPmxvl0if5vHBBp7pDYGkTFc7.jpg"),
                               urllogo: URL(string: "https://image.tmdb.org/t/p/w500/jI3wQkfTOSGEqhlSQYb4zIcEUl.png"),
                               descriptionMovie: """
                                Eight year old Peter is plagued by a mysterious, constant tapping from inside his bedroom wall—one that his parents insist is all in his imagination. As Peter\'s fear intensifies, he believes that his parents could be hiding a terrible, dangerous secret and questions their trust.
                                """,
                               showMovieQuality: Bool.random()),
                         Movie(id: 709631, title: "Cobweb",
                               urlPoster: URL(string: "https://image.tmdb.org/t/p/w500/cGXFosYUHYjjdKrOmA0bbjvzhKz.jpg"),
                               urlBackdrop: URL(string: "https://image.tmdb.org/t/p/w500/nYDPmxvl0if5vHBBp7pDYGkTFc7.jpg"),
                               urllogo: URL(string: "https://image.tmdb.org/t/p/w500/jI3wQkfTOSGEqhlSQYb4zIcEUl.png"),
                               descriptionMovie: """
                                An intelligence operative for a shadowy global peacekeeping agency races to stop a hacker from stealing its most valuable — and dangerous — weapon.
                                """,
                               showMovieQuality: Bool.random()),
        ]
        
        
        mockMovie.forEach { realmService.saveMovie(movie: $0) }
    }
}
