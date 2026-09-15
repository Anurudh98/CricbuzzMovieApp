//
//  MovieListView.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

struct MovieListView: View {

    @Environment(AppDependencies.self) private var dependencies
    @Environment(FavoritesManager.self) private var favoritesManager
    @State private var viewModel: MovieListViewModel
    @State private var showFavoritesOnly = false

    init(viewModel: @autoclosure @escaping () -> MovieListViewModel) {
        _viewModel = State(wrappedValue: viewModel())
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        NavigationStack {
            content
                .navigationTitle(showFavoritesOnly ? "Favorites" : "Movies")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            withAnimation(.snappy) { showFavoritesOnly.toggle() }
                        } label: {
                            Image(systemName: showFavoritesOnly ? "heart.fill" : "heart")
                                .foregroundStyle(showFavoritesOnly ? .red : .primary)
                        }
                        .accessibilityLabel(showFavoritesOnly ? "Show all movies" : "Show favorites")
                    }
                }
                .navigationDestination(for: Movie.self) { movie in
                    MovieDetailView(
                        viewModel: dependencies.makeMovieDetailViewModel(for: movie)
                    )
                }
                .searchable(
                    text: $viewModel.searchText,
                    placement: .navigationBarDrawer(displayMode: .always),
                    prompt: showFavoritesOnly ? "Search favorites" : "Search movies"
                )
                .onChange(of: viewModel.searchText) {
                    guard !showFavoritesOnly else { return }
                    viewModel.onSearchTextChanged()
                }
        }
        .task { await viewModel.onAppear() }
    }

    @ViewBuilder
    private var content: some View {
        if showFavoritesOnly {
            favoritesContent
        } else {
            popularContent
        }
    }

    @ViewBuilder
    private var popularContent: some View {
        if viewModel.isLoading && viewModel.movies.isEmpty {
            LoadingView(message: "Loading movies…")
        } else if let error = viewModel.errorMessage, viewModel.movies.isEmpty {
            ErrorView(message: error) {
                Task { await viewModel.refresh() }
            }
        } else if viewModel.movies.isEmpty {
            EmptyStateView(
                title: "No Movies Found",
                message: viewModel.searchText.isEmpty
                    ? "Popular movies will appear here."
                    : "Try a different search term."
            )
        } else {
            movieList
        }
    }

    @ViewBuilder
    private var favoritesContent: some View {
        let movies = filteredFavorites
        if movies.isEmpty {
            EmptyStateView(
                title: "No Favorites Yet",
                message: "Tap the heart on any movie to save it here.",
                systemImage: "heart"
            )
        } else {
            List(movies) { movie in
                NavigationLink(value: movie) {
                    MovieRowView(movie: movie)
                }
            }
            .listStyle(.plain)
        }
    }

    private var movieList: some View {
        List {
            ForEach(viewModel.movies) { movie in
                NavigationLink(value: movie) {
                    MovieRowView(movie: movie)
                }
                .task { await viewModel.loadNextPageIfNeeded(currentItem: movie) }
            }

            if viewModel.isLoadingNextPage {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .refreshable { await viewModel.refresh() }
    }

    private var filteredFavorites: [Movie] {
        let query = viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let favorites = favoritesManager.favorites
        guard !query.isEmpty else { return favorites }
        return favorites.filter { $0.title.localizedCaseInsensitiveContains(query) }
    }
}
