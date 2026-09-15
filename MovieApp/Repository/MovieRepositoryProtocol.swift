//
//  MovieRepositoryProtocol.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

protocol MovieRepositoryProtocol {

    func popularMovies(page: Int) async throws -> PagedResponse<Movie>

    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie>

    func movieDetail(id: Int) async throws -> MovieDetail

    func movieVideos(id: Int) async throws -> [Video]
}
