//
//  GroupDetailView.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/6/21.
//

import SwiftUI
import FirebaseStorage

struct GroupDetailView: View {
    var group: Group
    var friends: [User]
    @State var movie_match = [Movie]()
    @State private var showingMovieDetails = false
    @State private var admin_profile_picture: UIImage?
    @AppStorage("user_mongo_id") var user_mongo_id: String = "undefined"

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Spacer()
                    Text(group.title)
                        .font(.title)
                    Spacer()
                }
                ScrollView(.horizontal) {
                    HStack {
                        VStack {
                            if admin_profile_picture != nil {
                                Image(uiImage: admin_profile_picture!)
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
                            Text(group.user.username)
                                .font(Font.custom("OpenSans-Bold", size: 12))
                                .frame(width: 80)
                                .lineLimit(1)
                        }
                        .onAppear {
                            let image_name = "\(group.user._id) \("_profile_img")"
                            Storage.storage().reference().child(image_name).getData(maxSize: 4 * 1024 * 1024) {
                                (imageData, err) in
                                if let err = err {
                                    print("An error occured - \(err.localizedDescription)")
                                } else {
                                    if let imageData = imageData {
                                        self.admin_profile_picture = UIImage(data: imageData)
                                    } else {
                                        print("couldn't get image profile")
                                    }
                                }
                            }
                        }
                        ForEach(friends, id: \.self) { member in
                            VStack {
                                LoadProfilePicture(user_mongo_id: member._id)
                                Text(member.username)
                                    .font(Font.custom("OpenSans-Bold", size: 12))
                                    .frame(width: 80)
                                    .lineLimit(1)
                            }
                        }
                    }
                }
                .padding()
                VStack {
                    ScrollView {
                        HStack {
                            ForEach(group.services) { service in
                                HStack {
                                    Text(service.label)
                                        .padding(.leading, 10)
                                        .padding(.trailing, 10)
                                        .padding(.top, 10)
                                        .padding(.bottom, 10)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                        .foregroundColor(.white)
                                }
                                .padding(.trailing, 5)
                            }
                            Spacer()
                        }
                    }
                }

                HStack {
                    Text("Everybody loves 👇")
                        .font(.headline)
                    Spacer()
                }

                HStack {
                    if (movie_match.count > 0) {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(movie_match) { movie in
                                        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                                        RemoteImage(url: movie.img)
                                        LinearGradient(gradient: .init(colors: [Color.black.opacity(0),Color.black.opacity(0.4)]), startPoint: .center, endPoint: .bottom)
                                        VStack {
                                            HStack {
                                                VStack(alignment: .leading) {
                                                    Text(movie.title)
                                                        .font(.title)
                                                        .fontWeight(.bold)
                                                        .padding(.leading, 30)
                                                    Text("18" + " +")
                                                        .fontWeight(.bold)
                                                        .padding(.leading, 30)
                                                }
                                                .foregroundColor(.white)
                                                Spacer(minLength: 0)
                                            }
                                        }
                                        .padding(.all)
                                    })
                                    .frame(width: 350 ,height: 600)
                                    .cornerRadius(20)
                                }
                            }
                        }
                    } else {
                        HStack {
                            Spacer()
                            Image("nomovie")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 200, height: 200)
                                .cornerRadius(50.0)
                            Spacer()
                        }
                        .padding(.top, 100)
                    }
                }
                .onAppear {
                    Group_Api().get_match_movie_list(group_id: group._id) { (movie_match) in
                        self.movie_match = movie_match
                    }
                }
                Spacer()
            }
            .padding()
        }
    }
}

struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Group(
            _id: "602594cf7ad39611b4600bd8",
            title: "My group",
            user: User(username: "username", _id: "_id", firstName: "firstname", email: "email", userId: "userId", lastName: "lastname",  __v: 0),
            friends: [User(username: "username", _id: "_id", firstName: "firstname", email: "email", userId: "userId", lastName: "lastname",  __v: 0)],
            users_complete_list: [""],
            list_movie: [""],
            list_movie_liked: [""],
            list_movie_disliked: [""],
            match_movie: [""],
            services: []
        ), friends: []
        )
    }
}
