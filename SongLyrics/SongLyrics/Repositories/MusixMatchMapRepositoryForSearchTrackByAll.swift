//
//  MusixMatchMapRepositoryForSearchTrackByAll.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 23.12.2021.
//

import Foundation

class MusixMatchMapRepositoryForSearchTrackByAll: MusixMatchMapRepository {
    override init() {
        super.init()
        
        self.urlComposerForGetTrackList = APIMusixMatchMapURLComposerForGetTrackListByAll()
    }
}
