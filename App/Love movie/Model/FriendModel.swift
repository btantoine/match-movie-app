//
//  FriendModel.swift
//  Love movie
//
//  Created by Antoine Boudet on 7/23/21.
//

import SwiftUI

struct Friends: Codable, Identifiable {
    let id = UUID()
    var _id: String
    var user: String
    var friends: [User]
}
