//
//  APILyricMapURLComposerForGetTrackList.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 23.12.2021.
//

import Foundation

class APIMusixMatchMapURLComposerForGetTrackList: APILyricMapURLComposerForGetTrackList {
    let apiKey: String = "339038aaacb29db79872b63e7098e129"
    let baseUrl: String = "https://api.musixmatch.com/ws/1.1/track.search"
    let requestPageSize: String = "page_size=30"
}

class APIMusixMatchMapURLComposerForGetTrackListByTrack: APIMusixMatchMapURLComposerForGetTrackList {
    override func composeRequestForSearch (_ request: SearchRequst) -> URL? {
        guard let track = request.wordsSearch else {
            return nil
        }
        
        let requestParameters = "?q_track=\(track)&\(requestPageSize)&page=\(String(describing: request.searchNumberPage))&apikey=\(apiKey)"
        
        return URL(string: baseUrl + requestParameters)
    }
}

class APIMusixMatchMapURLComposerForGetTrackListByArtist: APIMusixMatchMapURLComposerForGetTrackList {
    override func composeRequestForSearch (_ request: SearchRequst) -> URL? {
        guard let artist = request.wordsSearch else {
            return nil
        }
        
        let requestParameters = "?q_artist=\(artist)&\(requestPageSize)&page=\(String(describing: request.searchNumberPage))&apikey=\(apiKey)"
        
        return URL(string: baseUrl + requestParameters)
    }
}

class APIMusixMatchMapURLComposerForGetTrackListByAll: APIMusixMatchMapURLComposerForGetTrackList {
    override func composeRequestForSearch (_ request: SearchRequst) -> URL? {
        guard let artist = request.wordsSearch else {
            return nil
        }
        
        let requestParameters = "?q_track_artist=\(artist)&\(requestPageSize)&page=\(String(describing: request.searchNumberPage))&apikey=\(apiKey)"
        
        return URL(string: baseUrl + requestParameters)
    }
}
