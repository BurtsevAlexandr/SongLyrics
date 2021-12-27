//
//  APILyricMapRepository.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 22.12.2021.
//

import Foundation

class APILyricMapRepository: APILyricRepository {
    var urlComposerForGetTrackList: APILyricMapURLComposerForGetTrackList!
    var urlComposerForGetLyric: APILyricMapURLComposerForGetLyric!
    
    func loadingFoundTracks(_ request: SearchRequst, completionHandler: @escaping ((Result<ServerResponseToSearchQuery, APILyricRepositoryError>) -> Void)) {
        guard let url = urlComposerForGetTrackList?.composeRequestForSearch(request) else {
            DispatchQueue.main.async {
                completionHandler(.failure(.badRequest))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if data == nil {
                print("Invalid request")
            }
            guard let tracklList = self.parseTrackDataForSearch(for: data!) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.badRequest))
                }
                return
            }
            let pageInfo = PageInfo(hasMorePage: self.checkOnNextPage(for: tracklList), currentPageNumber: request.searchNumberPage)
            let serverResponseToSearchQuery = ServerResponseToSearchQuery(trackList: tracklList, pageInfo: pageInfo )
            completionHandler(.success(serverResponseToSearchQuery))
        }
        .resume()
    }
    
    func loadingLyric(_ track: TrackData, completionHandler: @escaping ((Result<String, APILyricRepositoryError>) -> Void)) {
        guard let url = urlComposerForGetLyric.composeRequestForGetLyric(track) else {
            DispatchQueue.main.async {
                completionHandler(.failure(.lyricNotFound))
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if data == nil {
                print("Invalid request")
            }
            guard let lyric = self.parseTrackDataForGetLyric(for: data!) else {
                DispatchQueue.main.async {
                    completionHandler(.failure(.badRequest))
                }
                return
            }
            completionHandler(.success(lyric))
        }
        .resume()
    }
    
    func parseTrackDataForSearch (for data: Data) -> [TrackData]? {
        fatalError()
    }
    
    func parseTrackDataForGetLyric (for data: Data) -> String? {
        fatalError()
    }
    
    func checkOnNextPage (for trackList: [TrackData]) -> Bool {
        fatalError()
    }
}
