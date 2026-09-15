//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class MovieDetailViewModel {

    private(set) var detail: MovieDetail?
    private(set) var trailer: Video?
    private(set) var cast: [CastMember] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    @ObservationIgnored private let movieId: Int
    @ObservationIgnored private let repository: MovieRepositoryProtocol

    let listMovie: Movie

    init(movie: Movie, repository: MovieRepositoryProtocol) {
        self.movieId = movie.id
        self.listMovie = movie
        self.repository = repository
    }

    func load() async {
        guard detail == nil else { return }

        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            async let detailTask = repository.movieDetail(id: movieId)
            async let videosTask = repository.movieVideos(id: movieId)

            let (loadedDetail, videos) = try await (detailTask, videosTask)

            self.detail = loadedDetail
            self.trailer = videos.bestTrailer
            self.cast = loadedDetail.cast
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
        }
    }

    var favoritableMovie: Movie {
        detail?.asMovie ?? listMovie
    }
}
