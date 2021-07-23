//
//  LoadProfilePicture.swift
//  Match Movie
//
//  Created by Antoine Boudet on 3/8/21.
//

import SwiftUI
import FirebaseStorage

struct LoadProfilePicture: View {
    @State private var imageLoaded: UIImage?
    @State var user_mongo_id: String

    var body: some View {
        VStack {
            if imageLoaded != nil {
                Image(uiImage: imageLoaded!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
            } else {
               Image("avatar1")
                   .renderingMode(.original)
                   .resizable()
                   .clipShape(Circle())
                   .frame(width: 50, height: 50)
           }
        }
        .onAppear {
            let image_name = "\(user_mongo_id) \("_profile_img")"
            Storage.storage().reference().child(image_name).getData(maxSize: 4 * 1024 * 1024) {
                (imageData, err) in
                if let err = err {
                    print("An error occured - \(err.localizedDescription)")
                } else {
                    if let imageData = imageData {
                        self.imageLoaded = UIImage(data: imageData)
                    } else {
                        print("couldn't get image profile")
                    }
                }
            }
        }
    }
}

struct LoadProfilePicture_Previews: PreviewProvider {
    static var previews: some View {
        LoadProfilePicture(user_mongo_id: "")
    }
}
