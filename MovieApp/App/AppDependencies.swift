//
//  AppDependencies.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

@MainActor
@Observable
final class AppDependencies {

    let repository: MovieRepositoryProtocol
    let favoritesManager: FavoritesManager

    init(
        repository: MovieRepositoryProtocol = MovieRepository(apiClient: APIClient()),
        favoritesManager: FavoritesManager? = nil
    ) {
        self.repository = repository
        self.favoritesManager = favoritesManager ?? FavoritesManager()
    }

    func makeMovieListViewModel() -> MovieListViewModel {
        MovieListViewModel(repository: repository)
    }

    func makeMovieDetailViewModel(for movie: Movie) -> MovieDetailViewModel {
        MovieDetailViewModel(movie: movie, repository: repository)
    }
}
