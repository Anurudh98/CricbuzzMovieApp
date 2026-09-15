//
//  MovieDetailView.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

struct MovieDetailView: View {

    @State private var viewModel: MovieDetailViewModel

    init(viewModel: @autoclosure @escaping () -> MovieDetailViewModel) {
        _viewModel = State(wrappedValue: viewModel())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                metaSection
                genresSection
                plotSection
                castSection
            }
            .padding(.bottom, 32)
        }
        .navigationTitle(currentTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                FavoriteButton(movie: viewModel.favoritableMovie)
                    .font(.title3)
            }
        }
        .overlay {
            if viewModel.isLoading && viewModel.detail == nil {
                LoadingView(message: "Loading details…")
            }
        }
        .task { await viewModel.load() }
    }

    @ViewBuilder
    private var header: some View {
        ZStack {
            if let trailer = viewModel.trailer {
                TrailerPlayerView(video: trailer)
            } else {
                RemoteImageView(url: backdropURL)
            }
        }
        .frame(height: 220)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .clipped()
    }

    private var metaSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(currentTitle)
                .font(.title2.bold())

            if let tagline = viewModel.detail?.tagline, !tagline.isEmpty {
                Text(tagline)
                    .font(.subheadline.italic())
                    .foregroundStyle(.secondary)
            }

            HStack(spacing: 14) {
                if let year = viewModel.detail?.releaseYear ?? viewModel.listMovie.releaseYear {
                    Label(year, systemImage: "calendar")
                }
                if let runtime = viewModel.detail?.formattedRuntime {
                    Label(runtime, systemImage: "clock")
                }
                RatingBadge(rating: viewModel.detail?.formattedRating ?? viewModel.listMovie.formattedRating)
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    private var genresSection: some View {
        if let genres = viewModel.detail?.genres, !genres.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(genres) { genre in
                        Text(genre.name)
                            .font(.caption.weight(.medium))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.secondarySystemBackground))
                            .clipShape(Capsule())
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private var plotSection: some View {
        let overview = viewModel.detail?.overview ?? viewModel.listMovie.overview
        if !overview.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Text("Overview")
                    .font(.headline)
                Text(overview)
                    .font(.body)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private var castSection: some View {
        if !viewModel.cast.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                Text("Cast")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .top, spacing: 14) {
                        ForEach(viewModel.cast.prefix(15)) { member in
                            CastCardView(member: member)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }

    private var currentTitle: String {
        viewModel.detail?.title ?? viewModel.listMovie.title
    }

    private var backdropURL: URL? {
        viewModel.detail?.backdropURL
            ?? viewModel.listMovie.backdropURL
            ?? viewModel.listMovie.posterURL
    }
}
