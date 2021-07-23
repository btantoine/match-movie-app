//
//  SwiftUIView.swift
//  Match Movie
//
//  Created by Antoine Boudet on 7/23/21.
//

import SwiftUI

struct Group: Codable, Identifiable {
    let id = UUID()
    var _id: String
    var title: String
    var user: User
    var friends: [User]
    var users_complete_list: [String]
    var list_movie: [String]
    var list_movie_liked: [String]
    var list_movie_disliked: [String]
    var match_movie: [String]
    var services: [Service]
}
