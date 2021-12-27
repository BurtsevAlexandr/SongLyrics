//
//  APILyricRepository.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 22.12.2021.
//

import Foundation

enum APILyricRepositoryError: Error {
    case badRequest
    case lyricNotFound
}

protocol APILyricRepository: AnyObject {
    func loadingFoundTracks (_ request: SearchRequst, completionHandler: @escaping ((Result<ServerResponseToSearchQuery, APILyricRepositoryError>) -> Void))
    func loadingLyric (_ track: TrackData, completionHandler: @escaping ((Result<String, APILyricRepositoryError>) -> Void))
}
