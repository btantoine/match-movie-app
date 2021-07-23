//
//  Friends.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/7/21.
//

import SwiftUI

class Friends_Api {
    func get_friends(user_id: String, completion: @escaping (Friends) -> ()) {
        guard let url = URL(string: "http://<ip_address>:8080/api/friends?user_id=" + user_id)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let friends = try JSONDecoder().decode(Friends.self, from: data)
            DispatchQueue.main.async {
                completion(friends)
            }}
            catch { return }
        }
        .resume()
    }

    func post_friend(
        user: String,
        new_friend: String,
        completion: @escaping ([String: Any]?, Error?) -> Void) {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = [
            "user": user,
            "new_friend": new_friend,
        ]
        //create the url with NSURL
        let url = URL(string: "http://<ip_address>:8080/api/friends/add")!
        //create the session object
        let session = URLSession.shared
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
        } catch let error {
            print(error.localizedDescription)
            completion(nil, error)
        }
        //HTTP Headers
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            guard error == nil else {
                completion(nil, error)
                return
            }
            guard let data = data else {
                completion(nil, NSError(domain: "dataNilError", code: -100001, userInfo: nil))
                return
            }
            do {
                //create json object from data
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else {
                    completion(nil, NSError(domain: "invalidJSONTypeError", code: -100009, userInfo: nil))
                    return
                }
                completion(json, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(nil, error)
            }
        })
        task.resume()
    }
}
