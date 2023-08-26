//
//  TMDBLogoResponseNetworkModel.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import Foundation

struct TMDBLogoResponseNetworkModel: Decodable {
    let logos: [LogoNetworkModel]

    enum CodingKeys: String, CodingKey {
        case logos = "logos"
    }
}
