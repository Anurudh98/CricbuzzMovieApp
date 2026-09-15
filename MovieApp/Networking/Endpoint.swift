//
//  Endpoint.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

struct Endpoint {

    let path: String

    let queryItems: [URLQueryItem]

    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }

    func url() throws -> URL {
        var components = URLComponents(string: APIConfiguration.baseURL + path)

        var items = [URLQueryItem(name: "api_key", value: APIConfiguration.apiKey)]
        items.append(contentsOf: queryItems)
        components?.queryItems = items

        guard let url = components?.url else {
            throw NetworkError.invalidUrl
        }
        return url
    }
}

extension Endpoint {

    static func popularMovies(page: Int) -> Endpoint {
        Endpoint(
            path: "/movie/popular",
            queryItems: [URLQueryItem(name: "page", value: String(page))]
        )
    }

    static func movieDetail(id: Int) -> Endpoint {
        Endpoint(
            path: "/movie/\(id)",
            queryItems: [URLQueryItem(name: "append_to_response", value: "credits")]
        )
    }

    static func movieVideos(id: Int) -> Endpoint {
        Endpoint(path: "/movie/\(id)/videos")
    }

    static func searchMovies(query: String, page: Int) -> Endpoint {
        Endpoint(
            path: "/search/movie",
            queryItems: [
                URLQueryItem(name: "query", value: query),
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "include_adult", value: "false")
            ]
        )
    }
}
