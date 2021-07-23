//
//  MovieModel.swift
//  Love movie
//
//  Created by Antoine Boudet on 7/23/21.
//

import SwiftUI

struct Movie: Codable, Identifiable {
    var id : String
    var type : String
    var title : String
    var img : String
    var description : String
    var grade : String
    var genres : String
    var rated : String
    var dateCreated : String
    var duration : String
    var tags : String
    var country : String
    var servicesLink : String
    var services : [Service]
    var offset : CGFloat
    var nb_current_picture : Int
}

struct SmallMovie: Codable, Identifiable {
    var id : String
    var title : String
    var img : String
}
