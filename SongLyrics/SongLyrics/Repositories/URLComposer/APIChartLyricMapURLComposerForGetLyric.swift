//
//  APIChartLyricMapURLComposerForGetLyric.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 27.12.2021.
//

import Foundation

class APIChartLyricMapURLComposerForGetLyric: APILyricMapURLComposerForGetLyric {
    let baseUrl: String = "http://api.chartlyrics.com/apiv1.asmx/GetLyric"
    
    override func composeRequestForGetLyric (_ track: TrackData) -> URL? {
        let lyricId = track.hasLyric
        let lyricCheckSum = track.lyricChecksum
        let requestParameters = "?lyricId=\(lyricId)&lyricCheckSum=\(lyricCheckSum)"
        
        return URL(string: baseUrl + requestParameters)
    }
}
