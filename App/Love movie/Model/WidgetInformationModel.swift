//
//  WidgetInformationModel.swift
//  Love movie
//
//  Created by Antoine Boudet on 7/23/21.
//

import SwiftUI

struct WidgetInformation: Codable, Identifiable {
    let id = UUID()
    var title: String
    var match_movie: [SmallMovie]
    var services: [Service]
}
