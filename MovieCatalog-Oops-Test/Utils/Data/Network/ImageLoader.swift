//
//  ImageLoader.swift
//  MovieCatalog-Oops-Test
//
//  Created by Vladislav on 8/25/23.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    
    private let cache = NSCache<NSURL, UIImage>()
    
    func downloadImage(from urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw ImageError.invalidURL
        }
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        guard let image = UIImage(data: data) else {
            throw ImageError.invalidImageData
        }
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
    
    func cacheImage(_ image: UIImage, for urlString: String) {
         guard let url = URL(string: urlString) else {
             return
         }
         cache.setObject(image, forKey: url as NSURL)
     }
}
