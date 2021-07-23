//
//  ServiceModel.swift
//  Love movie
//
//  Created by Antoine Boudet on 7/23/21.
//

import SwiftUI

struct Service: Codable, Identifiable {
    let id = UUID()
    var _id: String
    var title: String
    var label: String
}
