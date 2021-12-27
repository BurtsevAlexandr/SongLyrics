//
//  ChartLyricMapRepositoryForSearchTrackByTrackAndArtist.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 23.12.2021.
//

import Foundation

class ChartLyricMapRepositoryForSearchTrackByTrackAndArtist: ChartLyricMapRepository {
    override init() {
        super.init()
        
        self.urlComposerForGetTrackList = APIChartLyricMapURLComposerForGetTrackListByArtistAndTrack()
    }
}
