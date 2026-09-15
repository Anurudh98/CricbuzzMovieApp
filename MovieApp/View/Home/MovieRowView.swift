//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

struct MovieRowView: View {

    let movie: Movie

    var body: some View {
        HStack(spacing: 12) {
            RemoteImageView(url: movie.posterURL)
                .frame(width: 70, height: 105)
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 6) {
                Text(movie.title)
                    .font(.headline)
                    .lineLimit(2)

                if let year = movie.releaseYear {
                    Label(year, systemImage: "calendar")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                RatingBadge(rating: movie.formattedRating)

                Text(movie.overview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 4)

            FavoriteButton(movie: movie)
                .font(.title3)
        }
        .padding(.vertical, 4)
    }
}
