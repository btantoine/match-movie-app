//
//  URLImageView.swift
//  Match Movie WidgetExtension
//
//  Created by Antoine Boudet on 3/25/21.
//

import SwiftUI

struct URLImageView: View {
    let url: URL

    @ViewBuilder
    var body: some View {
        if let data = try? Data(contentsOf: url), let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .cornerRadius(5.0)
        } else {
            Image(systemName: "photo")
        }
    }
}
