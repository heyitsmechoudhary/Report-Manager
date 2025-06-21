//
//  User.swift
//  Report Manager
//
//  Created by Rahul choudhary on 21/06/25.
//

import Foundation


struct User: Codable {
    let id: String
    let email: String
    let name: String
    let photoURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case id = "user_id"
        case email = "user_email"
        case name = "user_name"
        case photoURL = "photo_url"
    }
}
