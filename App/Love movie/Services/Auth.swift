//
//  Auth.swift
//  Love movie
//
//  Created by Antoine Boudet on 2/11/21.
//

import Foundation

class Auth_Api {

    func get_full_userInfo(userId: String, completion: @escaping (AuthUserFullData) -> ()) {
        guard let url = URL(string: "http://<ip_address>:8080/api/auth/full_info?userId=" + userId)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let userInfo = try JSONDecoder().decode(AuthUserFullData.self, from: data)
            DispatchQueue.main.async {
                completion(userInfo)
            }}
            catch { print("return get_full_userInfo"); return}
        }
        .resume()
    }
    
    func get_userInfo(user_id: String, completion: @escaping ([String]) -> ()) {
        guard let url = URL(string: "http://<ip_address>:8080/api/auth?user_id=" + user_id)
        else { return }
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else { return }
            do {let userInfo = try JSONDecoder().decode([String].self, from: data)
            DispatchQueue.main.async {
                completion(userInfo)
            }}
            catch { print("return get_userInfo"); completion([])}
        }
        .resume()
    }

    func post_user_signIn_with_apple(
        userId: String,
        firstName: String,
        lastName: String,
        email: String,
        completion: @escaping ([String: Any]?, Error?) -> Void) {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = [
            "userId": userId,
            "firstName": firstName,
            "lastName": lastName,
            "email": email,
        ]
        //create the url with NSURL
        let url = URL(string: "http://<ip_address>:8080/api/auth/signInWithApple")!
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
    
    func post_username(
        userId: String,
        username: String,
        completion: @escaping ([String: Any]?, Error?) -> Void) {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = [
            "userId": userId,
            "username": username
        ]
        //create the url with NSURL
        let url = URL(string: "http://<ip_address>:8080/api/auth/username")!
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
    
    func delete_user(
        user_id: String,
        completion: @escaping ([String: Any]?, Error?) -> Void) {
        //declare parameter as a dictionary which contains string as key and value combination.
        let parameters = [
            "user_id": user_id
        ]
        //create the url with NSURL
        let url = URL(string: "http://<ip_address>.232:8080/api/auth")!
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
