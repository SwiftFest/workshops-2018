//
//  Reservation.swift
//  SwiftFest
//
//  Created by Matthew Dias on 4/21/18.
//  Copyright © 2018 Matt Dias. All rights reserved.
//

import Foundation

struct Reservation: Codable {
    var id: Int
    var restaurant: Restaurant
    var date: String
    var partySize: Int
}
