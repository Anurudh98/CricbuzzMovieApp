//
//  PagedResponse.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

struct PagedResponse<Element: Codable>: Codable {
    let page: Int
    let results: [Element]
    let totalPages: Int
    let totalResults: Int
}
