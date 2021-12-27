//
//  SearchResponse.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 27.12.2021.
//

import Foundation

struct ServerResponseToSearchQuery {
    var trackList: [TrackData]
    var pageInfo: PageInfo
}
