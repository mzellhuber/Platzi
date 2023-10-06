//
//  ImageLoader.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 05/10/23.
//

import UIKit

class ImageLoader {
    func loadImage(from urlString: String) async -> UIImage? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            }
        } catch {
            print("Failed to load image: \(error)")
        }
        
        return nil
    }
}
