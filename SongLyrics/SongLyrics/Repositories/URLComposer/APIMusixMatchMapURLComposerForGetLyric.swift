//
//  APIMusixMatchMapURLComposerForGetLyric.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 27.12.2021.
//

import Foundation

class APIMusixMatchMapURLComposerForGetLyric: APILyricMapURLComposerForGetLyric {
    let apiKey: String = "339038aaacb29db79872b63e7098e129"
    let baseUrl: String = "https://api.musixmatch.com/ws/1.1/track.lyrics.get"
    
    override func composeRequestForGetLyric (_ track: TrackData) -> URL? {
        let trackId = track.trackId
        let requestParameters = "?track_id=\(trackId)&apikey=\(apiKey)"
        
        return URL(string: baseUrl + requestParameters)
    }
}
