//
//  APILyricsManager.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 14.10.2021.
//

import Foundation
import UIKit

protocol QueryManagerDelegateForGetLyric: AnyObject {
    func setLyric(_: QueryManagerForAPI, with APIData: TrackData)
    func showError(_: QueryManagerForAPI)
}

protocol QueryManagerDelegateForSearchTracks: AnyObject {
    func updateTableData(_: QueryManagerForAPI, with APIData: [TrackData])
    func showError(_: QueryManagerForAPI)
}

class QueryManagerForAPI {
    
    weak var delegateSearch: QueryManagerDelegateForSearchTracks?
    weak var delegateGetLyric: QueryManagerDelegateForGetLyric?
    var task: URLSessionDataTask?
    var xmlParserForSearch = XMLParserForSearch()
    var xmlParserForGetLyric = XMLParserForGetLyric()
    var parcerJSON = JSONParser()
    
    func searchInApiLibrary(for searchObject: ModelObjectSearch) {
        var urlString: String
        if searchObject.markOfSelectedLibrary == ListAPI.musixMatch {
            if searchObject.markOfSearchAttribute == ListSearchAtributes.artist {
                urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_artist=\(searchObject.wordsSearch!)&page_size=30&page=\(searchObject.searchNumberPage!)&apikey=339038aaacb29db79872b63e7098e129"
            }
            else if searchObject.markOfSearchAttribute == ListSearchAtributes.track {
                urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_track=\(searchObject.wordsSearch!)&page_size=30&page=\(searchObject.searchNumberPage!)&apikey=339038aaacb29db79872b63e7098e129"
            }
            else {
                urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_track_artist=\(searchObject.wordsSearch!)&page_size=30&page=\( searchObject.searchNumberPage!)&apikey=339038aaacb29db79872b63e7098e129"
            }
        }
        else {
            if searchObject.markOfSearchAttribute == ListSearchAtributes.artistAndTrack {
                urlString = "http://api.chartlyrics.com/apiv1.asmx/SearchLyric?artist=\(searchObject.artistName!)&song=\(searchObject.trackName!)"
            }
            else {
                urlString = "http://api.chartlyrics.com/apiv1.asmx/SearchLyricText?lyricText=\(searchObject.wordsSearch!)"
            }
        }
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: url!) { [self] data, response, error in
            if response != nil {
                if let data = data {
                    if searchObject.markOfSelectedLibrary == ListAPI.musixMatch {
                        if let arrayParseSongs = parcerJSON.parseJSONForSearchInAPIMusixMatch(withData: data) {
                            self.delegateSearch?.updateTableData(self, with: arrayParseSongs)
                        }
                    }
                    else {
                        if let arrayParseSongs = xmlParserForSearch.parseXMLForSearchInAPIChartLyric(withData: data) {
                            self.delegateSearch?.updateTableData(self, with: arrayParseSongs)
                        }
                    }
                }
            }
            else {
                if (error?.localizedDescription != Optional("cancelled")) {
                    self.delegateSearch?.showError(self)
                }
            }
        }
        task?.resume()
    }
    
    func getLyricOnAPILibrary(withTrack track: TrackData, for searchObject: ModelObjectSearch) {
        var urlString: String
        if searchObject.markOfSelectedLibrary == ListAPI.musixMatch {
            let id = track.trackId
            urlString = "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=\(id)&apikey=339038aaacb29db79872b63e7098e129"
        }
        else {
            let lyricId = track.hasLyric
            let lyricCheckSum = track.lyricChecksum
            urlString = "http://api.chartlyrics.com/apiv1.asmx/GetLyric?lyricId=\(lyricId)&lyricCheckSum=\(lyricCheckSum)"
            
        }
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: url!) { [weak self] data, response, error in
            if (response as? HTTPURLResponse) != nil {
                if let data = data {
                    if searchObject.markOfSelectedLibrary == ListAPI.musixMatch {
                        if let lyric = self?.parcerJSON.parseJSONForGetLyricInApiMusixMatch(withData: data) {
                            track.lyricBody = lyric
                            self?.delegateGetLyric?.setLyric(self!, with: track)
                        }
                    }
                    else {
                        if let lyryc = self?.xmlParserForGetLyric.parseXMLForGetLyricInAPIChartLyric(withData: data) {
                            track.lyricBody = lyryc
                            self?.delegateGetLyric?.setLyric(self!, with: track)
                        }
                    }
                }
            }
            else {
                self?.delegateGetLyric?.showError(self!)
            }
        }
        task?.resume()
    }
}
