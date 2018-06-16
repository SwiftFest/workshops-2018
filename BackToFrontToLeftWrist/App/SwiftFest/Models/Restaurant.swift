//
//  Restaurant.swift
//  SwiftFest
//
//  Created by Matthew Dias on 10/28/17.
//  Copyright © 2017 Matt Dias. All rights reserved.
//

import Foundation

struct Restaurant: Codable {
    var id: Int
    var name: String
    var website: String
    var phoneNumber: String
    var latitude: Double
    var longitude: Double
}
