//
//  CastMember.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

struct CastMember: Codable, Identifiable, Hashable {

    let id: Int
    let name: String
    let character: String?
    let profilePath: String?
    let order: Int

    var profileURL: URL? {
        APIConfiguration.imageURL(path: profilePath, size: .profile)
    }
}
