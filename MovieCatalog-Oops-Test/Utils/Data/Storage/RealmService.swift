//
//  MovieRealmService.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation

import RealmSwift
import SwiftUI


class RealmService: ObservableObject {
    // MARK: - Singleton
    static let shared = RealmService()
    
    // MARK: - Properties
    private let realm = try! Realm()
    var notificationToken: NotificationToken?
    @Published var movieUpdate = false
    
    // MARK: - Initialization
    init() {
        // Set up a notification token to observe changes in the MovieRealm objects
          notificationToken = realm.objects(MovieRealm.self).observe { [weak self] (changes: RealmCollectionChange) in
              switch changes {
              case .initial:
                  break
              case .update(_, _, _, _):
                  self?.movieUpdate = true
              case .error(let error):
                  fatalError("\(error)")
              }
          }
      }
    
    // MARK: - Database Operations
    
    func saveMovie(movie: Movie) {
        try! realm.write {
            let movieRealm = movie.toMovieRealm()
            realm.add(movieRealm, update: .modified)
        }
    }

    func getAllMovies() -> [Movie] {
        let movieRealms = realm.objects(MovieRealm.self)
        return movieRealms.map{$0.toMovie()}
    }
    
    func deleteMovie(movie: Movie) {
        if let movieRealm = realm.object(ofType: MovieRealm.self, forPrimaryKey: movie.id) {
            try! realm.write {
                realm.delete(movieRealm)
            }
        }
    }
}
