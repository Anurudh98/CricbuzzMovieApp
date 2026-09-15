//
//  RatingBadge.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

struct RatingBadge: View {

    let rating: String

    var body: some View {
        Label(rating, systemImage: "star.fill")
            .font(.caption.weight(.semibold))
            .foregroundStyle(.yellow)
            .labelStyle(.titleAndIcon)
    }
}

#Preview {
    RatingBadge(rating: "7.9")
}
