//
//  ImageLoader.swift
//  Love movie
//
//  Created by Antoine Boudet on 1/24/21.
//

import Foundation
import SwiftUI
import Combine

class ImageLoader:ObservableObject {
    @Published var downloadImage:UIImage?
    
    func fetchImage(url: String) {
        guard let imageUrl = URL(string: url) else { return; }
        URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            guard let data = data, error == nil else {
                return;
            }
            DispatchQueue.main.async {
                self.downloadImage = UIImage(data: data)
            }
        }.resume()
    }
}
