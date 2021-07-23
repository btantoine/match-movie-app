//
//  Preferences.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/8/21.
//

import SwiftUI

struct UserPreferences: Codable, Identifiable {
    let id = UUID()
    var type: String // userPreferences or swipe group list
    var list_movie: [Movie]
}

class UserPreferences_Api {
    func get_user_preferences(completion: @escaping (UserPreferences) -> ()) {
        guard let url = URL(string: "http://<ip_address>:8080/api/user_preferences/check?user=601c20c0b0606ed8a7ea1d11") // TODO: add a param for the id
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let user_preferences = try JSONDecoder().decode(UserPreferences.self, from: data)
            DispatchQueue.main.async {
                completion(user_preferences)
            }}
            catch { completion(UserPreferences(type: "null", list_movie: [])) }
        }
        .resume()
    }
}
