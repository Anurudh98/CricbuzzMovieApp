//
//  RemoteImageView.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

struct RemoteImageView: View {

    let url: URL?
    var contentMode: ContentMode = .fill

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            case .failure:
                placeholder(systemImage: "film")
            case .empty:
                ZStack {
                    Color(.secondarySystemBackground)
                    ProgressView()
                }
            @unknown default:
                placeholder(systemImage: "film")
            }
        }
    }

    private func placeholder(systemImage: String) -> some View {
        ZStack {
            Color(.secondarySystemBackground)
            Image(systemName: systemImage)
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
}
