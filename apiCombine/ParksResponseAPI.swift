//
//  ParksResponseAPI.swift
//  NPS
//
//  Created by Javier Calatrava on 8/2/21.
//

import Foundation

struct ParksResponseAPI: Codable {
    let total: String
    let limit: String
    let start: String
    let data: [ParkAPI]
}

struct ParkAPI: Codable {
    let id: String
    let url: String
    let name: String
}
