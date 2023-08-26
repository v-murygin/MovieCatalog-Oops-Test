//
//  NetworkService.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation

class NetworkService {
   
    let apiKey = "cab423ba8116166b681d9ee7d953273e"

    func getPopularMoviesTMDB() async throws -> [MovieTmdbNetworkModel] {
        let popularURL = "https://api.themoviedb.org/3/movie/popular"
        guard var components = URLComponents(string: popularURL) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw URLError(.badURL)
        }

        let responseObject: TMDBResponseNetworkModel = try await performRequest(URL: url)
        return responseObject.results
    }

    func getMoviesLogoTMDB(forMovieId id: Int) async throws -> URL? {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/images?api_key=\(apiKey)")!
        let responseObject: TMDBLogoResponseNetworkModel = try await performRequest(URL: url)
        
        let baseImageURL = "https://image.tmdb.org/t/p/w500"
        if let posterPath = responseObject.logos.first?.filePath {
            return URL(string: baseImageURL + posterPath)
        }
        return nil
    }
    
    private func performRequest<T: Decodable>(URL: URL) async throws -> T {
        let (data, _) = try await URLSession.shared.data(from: URL)
        return try JSONDecoder().decode(T.self, from: data)
    }
}
