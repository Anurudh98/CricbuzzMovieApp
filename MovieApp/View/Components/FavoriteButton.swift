//
//  FavoriteButton.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

struct FavoriteButton: View {

    let movie: Movie
    @Environment(FavoritesManager.self) private var favoritesManager

    var body: some View {
        Button {
            withAnimation(.snappy) {
                favoritesManager.toggle(movie)
            }
        } label: {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .symbolEffect(.bounce, value: isFavorite)
                .foregroundStyle(isFavorite ? .red : .secondary)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
    }

    private var isFavorite: Bool {
        favoritesManager.isFavorite(movie)
    }
}
