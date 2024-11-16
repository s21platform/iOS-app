//
//  UserProfile.swift
//  space21
//
//  Created by Марина on 23.10.2024.
//

import Foundation

struct UserProfile: Codable {
    let nickname: String
    let avatar: String
    let name: String?
    let surname: String?
    let birthdate: String?
    let phone: String?
    let city: String?
    let telegram: String?
    let git: String?
    let os: String?
    let work: String?
    let university: String?
    let skills: [String]?
    let hobbies: [String]?
}
