//
//  CastCardView.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

struct CastCardView: View {

    let member: CastMember

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RemoteImageView(url: member.profileURL)
                .frame(width: 90, height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Text(member.name)
                .font(.caption.weight(.semibold))
                .lineLimit(1)

            if let character = member.character, !character.isEmpty {
                Text(character)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .frame(width: 90)
    }
}
