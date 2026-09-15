//
//  Video.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

struct Video: Codable, Identifiable, Hashable {

    let id: String
    let key: String
    let name: String
    let site: String
    let type: String
    let official: Bool

    var isYouTube: Bool {
        site.caseInsensitiveCompare("YouTube") == .orderedSame
    }

    var isTrailer: Bool {
        type.caseInsensitiveCompare("Trailer") == .orderedSame
    }

    var youTubeURL: URL? {
        URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

struct VideosResponse: Codable {
    let id: Int
    let results: [Video]
}

extension Array where Element == Video {
    var bestTrailer: Video? {
        first { $0.isYouTube && $0.isTrailer && $0.official }
            ?? first { $0.isYouTube && $0.isTrailer }
            ?? first { $0.isYouTube }
    }
}
