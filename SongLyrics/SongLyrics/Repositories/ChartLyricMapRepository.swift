//
//  ChartLyricMapRepositoryForSearchTrack.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 24.12.2021.
//

import Foundation

class ChartLyricMapRepository: APILyricMapRepository {
    var xmlParserForSearch = XMLParserForSearch()
    var xmlParserForGetLyric = XMLParserForGetLyric()
    
    override init() {
        super.init()
        
        self.urlComposerForGetLyric = APIChartLyricMapURLComposerForGetLyric()
    }
    
    override func parseTrackDataForSearch(for data: Data) -> [TrackData]? {
        xmlParserForSearch.parseXMLForSearchInAPIChartLyric(withData: data)
    }
    
    override func parseTrackDataForGetLyric(for data: Data) -> String? {
        xmlParserForGetLyric.parseXMLForGetLyricInAPIChartLyric(withData: data)
    }
    
    override func checkOnNextPage (for trackList: [TrackData]) -> Bool {
        return false
    }
}
