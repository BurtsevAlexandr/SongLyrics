//
//  MusixMatchMapRepositoryForSearch.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 24.12.2021.
//

import Foundation

class MusixMatchMapRepository: APILyricMapRepository {
    var jsonParser = JSONParser()
    
    override init() {
        super.init()
        
        self.urlComposerForGetLyric = APIMusixMatchMapURLComposerForGetLyric()
    }
    
    override func parseTrackDataForSearch(for data: Data) -> [TrackData]? {
        jsonParser.parseJSONForSearchInAPIMusixMatch(withData: data)
    }
    
    override func parseTrackDataForGetLyric(for data: Data) -> String? {
        jsonParser.parseJSONForGetLyricInApiMusixMatch(withData: data)
    }
    
    override func checkOnNextPage (for trackList: [TrackData]) -> Bool {
        if trackList.count == 0 {
            return false
        }
        else {
            return true
        }
    }
}
