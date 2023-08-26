//
//  TMDBResponse.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation

struct TMDBResponseNetworkModel: Decodable {
    let results: [MovieTmdbNetworkModel]
}
