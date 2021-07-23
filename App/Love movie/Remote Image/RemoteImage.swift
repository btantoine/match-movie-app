//
//  RemoteImage.swift
//  Love movie
//
//  Created by Antoine Boudet on 1/24/21.
//

import SwiftUI

struct RemoteImage: View {
    @ObservedObject var imageLoader = ImageLoader()
    var placeholder: Image
    
    init(url: String, placeholder: Image = Image(systemName: "photo")) {
        self.placeholder = placeholder
        imageLoader.fetchImage(url: url)
    }
    var body: some View {
        if let image = self.imageLoader.downloadImage {
            Image(uiImage: image)
                .resizable()
        } else {
            Image("white_img")
                .resizable()
        }
    }
}

struct RemoteImage_Previews: PreviewProvider {
    static var previews: some View {
        RemoteImage(url: "")
    }
}
