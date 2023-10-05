//
//  ImageLoader.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import UIKit

class ImageLoader: ObservableObject {
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from urlString: String) async -> UIImage? {
        if let cachedImage = cache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                cache.setObject(image, forKey: urlString as NSString)
                return image
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        
        return nil
    }
}
