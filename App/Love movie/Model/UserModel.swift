//
//  UserModel.swift
//  Love movie
//
//  Created by Antoine Boudet on 7/23/21.
//

import SwiftUI

struct User: Codable, Identifiable, Hashable {
    let id = UUID()
    var username: String
    var _id: String
    var firstName: String
    var email: String
    var userId: String
    var lastName: String
    var __v: Int
}

struct AuthUser: Codable {
    let userId, firstName, lastName, email, authState: String
}

struct AuthUserFullData: Codable {
    let _id, userId, firstName, lastName, email, authState: String
}
