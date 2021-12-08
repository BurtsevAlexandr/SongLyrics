//
//  APILyricsManager.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 14.10.2021.
//

import Foundation
import UIKit

protocol APIManagerDelegate: AnyObject {
    func updateTableData(_: APIManager, with APIData: [TrackData])
    func setLyric(_: APIManager, with APIData: TrackData)
    func showError(_: APIManager)
}

class APIManager: NSObject, XMLParserDelegate  {
    
    weak var delegate: APIManagerDelegate?
    var task: URLSessionDataTask?
    var xmlParserForSearch = XMLParserForSearch()
    var xmlParserForGetLyric = XMLParserForGetLyric()
    var parcerJSON = JSONParser()
    
    func searchInApiLibrary(for searchObject: ModelObjectSearch) {
        var urlString: String
        if searchObject.markOfSelectedLibrary == "API-MusixMatch" {
            if searchObject.markOfSearchAttribute == "Artist" {
                urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_artist=\(searchObject.wordsSearch!)&page_size=30&page=\(searchObject.searchNumberPage!)&apikey=339038aaacb29db79872b63e7098e129"
            }
            else if searchObject.markOfSearchAttribute == "Track" {
                urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_track=\(searchObject.wordsSearch!)&page_size=30&page=\(searchObject.searchNumberPage!)&apikey=339038aaacb29db79872b63e7098e129"
            }
            else {
                urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_track_artist=\(searchObject.wordsSearch!)&page_size=30&page=\( searchObject.searchNumberPage!)&apikey=339038aaacb29db79872b63e7098e129"
            }
        }
        else {
            if searchObject.markOfSearchAttribute == "Atribute-Artist and track" {
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
                    if searchObject.markOfSelectedLibrary == "API-MusixMatch" {
                        if let arrayParseSongs = parcerJSON.parseJSONForSearchInAPIMusixMatch(withData: data) {
                            self.delegate?.updateTableData(self, with: arrayParseSongs)
                        }
                    }
                    else {
                        if let arrayParseSongs = xmlParserForSearch.parseXMLForSearchInAPIChartLyric(withData: data) {
                            self.delegate?.updateTableData(self, with: arrayParseSongs)
                        }
                    }
                }
            }
            else {
                if (error?.localizedDescription != Optional("cancelled")) {
                    self.delegate?.showError(self)
                }
            }
        }
        task?.resume()
    }
    
    func getLyricOnAPILibrary(withTrack track: TrackData, for searchObject: ModelObjectSearch) {
        var urlString: String
        if searchObject.markOfSelectedLibrary == "API-MusixMatch" {
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
                    if searchObject.markOfSelectedLibrary == "API-MusixMatch" {
                        if let lyric = self?.parcerJSON.parseJSONForGetLyricInApiMusixMatch(withData: data) {
                            track.lyricBody = lyric
                            self?.delegate?.setLyric(self!, with: track)
                        }
                    }
                    else {
                        if let lyryc = self?.xmlParserForGetLyric.parseXMLForGetLyricInAPIChartLyric(withData: data) {
                            track.lyricBody = lyryc
                            self?.delegate?.setLyric(self!, with: track)
                        }
                    }
                }
            }
            else {
                self?.delegate?.showError(self!)
            }
        }
        task?.resume()
    }
}
