//
//  Group.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/5/21.
//

import SwiftUI

class Group_Api {
    func get_widget_informations(user_id: String, completion: @escaping ([WidgetInformation]) -> ()) {
        guard let url = URL(string: "http://51.161.9.232:8080/api/crud_group/widgetInformations?user_id=" + user_id)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let groups = try JSONDecoder().decode([WidgetInformation].self, from: data)
            DispatchQueue.main.async {
                completion(groups)
            }}
            catch { print("return error"); return }
        }
        .resume()
    }

    func get_groups(user_id: String, completion: @escaping ([Group]) -> ()) {
        guard let url = URL(string: "http://51.161.9.232:8080/api/crud_group?user_id=" + user_id)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let groups = try JSONDecoder().decode([Group].self, from: data)
            DispatchQueue.main.async {
                completion(groups)
            }}
            catch { print("return"); completion([]) }
        }
        .resume()
    }

    func get_groups_by_invitation(user_id: String, completion: @escaping ([Group]) -> ()) {
        guard let url = URL(string: "http://51.161.9.232:8080/api/crud_group/by_invitation?user_id=" + user_id)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let groups = try JSONDecoder().decode([Group].self, from: data)
            DispatchQueue.main.async {
                completion(groups)
            }}
            catch { print("return"); completion([]) }
        }
        .resume()
    }
    
    func get_list_movie_by_groups_id(group_id: String, user_id: String, completion: @escaping ([Movie]) -> ()) {
        guard let url = URL(string: "http://51.161.9.232:8080/api/crud_group/get_by_id?group_id=" + group_id + "&user_id=" + user_id)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let movies = try JSONDecoder().decode([Movie].self, from: data)
            DispatchQueue.main.async {
                completion(movies)
            }}
            catch {
                print("return")
                return }
        }
        .resume()
    }

    func get_match_movie_list(group_id: String, completion: @escaping ([Movie]) -> ()) {
        guard let url = URL(string: "http://51.161.9.232:8080/api/crud_group/movie_match?group_id=" + group_id)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let match_movie = try JSONDecoder().decode([Movie].self, from: data)
            DispatchQueue.main.async {
                completion(match_movie)
            }}
            catch { print("return"); completion([]) }
        }
        .resume()
    }

    func get_match(user_id: String, completion: @escaping ([String]) -> ()) {
        guard let url = URL(string: "http://51.161.9.232:8080/api/crud_group/get_match?user_id=" + user_id) // user_id
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let match = try JSONDecoder().decode([String].self, from: data)
            DispatchQueue.main.async {
                completion(match)
            }}
            catch { print("return"); completion([]) }
        }
        .resume()
    }
    
    func post_group(
        title: String,
        user: String,
        friends: [String],
        type: String,
        services: [String],
        selectedGenreRows: [String], completion: @escaping ([String: Any]?, Error?) -> Void) {
        let parameters = [
            "title": title,
            "user": user,
            "friends": friends,
            "type": type,
            "services": services,
            "selectedGenreRows": selectedGenreRows
        ] as [String : Any]
        //create the url with NSURL
        let url = URL(string: "http://51.161.9.232:8080/api/crud_group")!
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
                completion(nil, error)
            }
        })
        task.resume()
    }

    func delete_group(
        user_id: String,
        _id: String,
        completion: @escaping ([String: Any]?, Error?) -> Void) {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = [
            "user_id": user_id,
            "_id": _id
        ]
        //create the url with NSURL
        let url = URL(string: "http://51.161.9.232:8080/api/crud_group")!
        //create the session object
        let session = URLSession.shared
        //now create the Request object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE" //set http method as POST
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
