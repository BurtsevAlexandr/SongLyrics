//
//  APIChartLyricMapURLComposerForGetTrackList.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 23.12.2021.
//

import Foundation

class APIChartLyricMapURLComposerForGetTrackList: APILyricMapURLComposerForGetTrackList {
    let baseUrl: String = "http://api.chartlyrics.com/apiv1.asmx/SearchLyric"
}

class APIChartLyricMapURLComposerForGetTrackListByArtistAndTrack: APIChartLyricMapURLComposerForGetTrackList {
    override func composeRequestForSearch (_ request: SearchRequst) -> URL? {
        guard let track = request.trackName else {
            return nil
        }
        
        guard let artist = request.artistName else {
            return nil
        }
        
        let requestParameters = "?artist=\(artist)&song=\(track)"
        
        return URL(string: baseUrl + requestParameters)
    }
}
