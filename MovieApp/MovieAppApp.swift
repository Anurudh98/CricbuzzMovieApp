//
//  MovieAppApp.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import SwiftUI

@main
struct MovieAppApp: App {

    @State private var dependencies = AppDependencies()

    var body: some Scene {
        WindowGroup {
            MovieListView(viewModel: dependencies.makeMovieListViewModel())
                .environment(dependencies)
                .environment(dependencies.favoritesManager)
        }
    }
}
