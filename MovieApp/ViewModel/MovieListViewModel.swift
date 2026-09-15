//
//  MovieListViewModel.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation
import Observation

@MainActor
@Observable
final class MovieListViewModel {

    var searchText = ""

    private(set) var movies: [Movie] = []

    private(set) var isLoading = false

    private(set) var isLoadingNextPage = false

    private(set) var errorMessage: String?

    @ObservationIgnored private let repository: MovieRepositoryProtocol
    @ObservationIgnored private var searchTask: Task<Void, Never>?

    @ObservationIgnored private var currentPage = 0
    @ObservationIgnored private var totalPages = 1

    private enum Mode: Equatable {
        case popular
        case search(String)
    }
    @ObservationIgnored private var mode: Mode = .popular

    init(repository: MovieRepositoryProtocol) {
        self.repository = repository
    }

    func onAppear() async {
        guard movies.isEmpty else { return }
        await loadPopular()
    }

    func onSearchTextChanged() {
        searchTask?.cancel()

        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)

        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(400))
            guard let self, !Task.isCancelled else { return }

            if query.isEmpty {
                guard self.mode != .popular else { return }
                await self.loadPopular()
            } else {
                await self.search(query: query)
            }
        }
    }

    func loadPopular() async {
        mode = .popular
        await loadFirstPage { repository, page in
            try await repository.popularMovies(page: page)
        }
    }

    private func search(query: String) async {
        mode = .search(query)
        await loadFirstPage { repository, page in
            try await repository.searchMovies(query: query, page: page)
        }
    }

    func refresh() async {
        switch mode {
        case .popular:
            await loadPopular()
        case .search(let query):
            await search(query: query)
        }
    }

    func loadNextPageIfNeeded(currentItem: Movie) async {
        guard
            !isLoading,
            !isLoadingNextPage,
            currentPage < totalPages,
            let index = movies.firstIndex(of: currentItem),
            index >= movies.count - 4
        else { return }

        isLoadingNextPage = true
        defer { isLoadingNextPage = false }

        do {
            let response = try await fetch(page: currentPage + 1)
            currentPage = response.page
            totalPages = response.totalPages
            appendUnique(response.results)
        } catch {
            errorMessage = message(for: error)
        }
    }

    private func loadFirstPage(
        using loader: @escaping (MovieRepositoryProtocol, Int) async throws -> PagedResponse<Movie>
    ) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let response = try await loader(repository, 1)
            currentPage = response.page
            totalPages = response.totalPages
            movies = response.results
        } catch {
            movies = []
            errorMessage = message(for: error)
        }
    }

    private func fetch(page: Int) async throws -> PagedResponse<Movie> {
        switch mode {
        case .popular:
            return try await repository.popularMovies(page: page)
        case .search(let query):
            return try await repository.searchMovies(query: query, page: page)
        }
    }

    private func appendUnique(_ newMovies: [Movie]) {
        let existingIds = Set(movies.map(\.id))
        movies.append(contentsOf: newMovies.filter { !existingIds.contains($0.id) })
    }

    private func message(for error: Error) -> String {
        (error as? LocalizedError)?.errorDescription ?? error.localizedDescription
    }
}
