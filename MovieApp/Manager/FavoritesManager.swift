//
//  FavoritesManager.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class FavoritesManager {

    private(set) var favoritesById: [Int: Movie] = [:]

    @ObservationIgnored private let storageKey = "favorite_movies"
    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        load()
    }

    var favorites: [Movie] {
        favoritesById.values.sorted { $0.title < $1.title }
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favoritesById[movie.id] != nil
    }

    func isFavorite(id: Int) -> Bool {
        favoritesById[id] != nil
    }

    func toggle(_ movie: Movie) {
        if favoritesById[movie.id] == nil {
            favoritesById[movie.id] = movie
        } else {
            favoritesById[movie.id] = nil
        }
        save()
    }

    private func save() {
        let movies = Array(favoritesById.values)
        if let data = try? JSONEncoder().encode(movies) {
            defaults.set(data, forKey: storageKey)
        }
    }

    private func load() {
        guard
            let data = defaults.data(forKey: storageKey),
            let movies = try? JSONDecoder().decode([Movie].self, from: data)
        else { return }

        favoritesById = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
    }
}
