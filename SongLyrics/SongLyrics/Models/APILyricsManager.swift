//
//  APILyricsManager.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 14.10.2021.
//

import Foundation
import UIKit

protocol APILyricsManagerDelegate: AnyObject {
    func updateTableData(_: APILyricsManager, with APIData: [TrackData])
    func setLyric(_: APILyricsManager, with APIData: TrackData)
    func showError(_: APILyricsManager)
}

class APILyricsManager: NSObject, XMLParserDelegate  {
    
    weak var delegate: APILyricsManagerDelegate?
    var task: URLSessionDataTask?
    var tracks = [TrackData]()
    var elementName: String = String()
    var song: String = ""
    var lyricID: Int = 0
    var artist: String = ""
    var lyricChecksum: String = ""
    
    
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
                        if let arrayParseSongs = self.parseJSONForSearchInAPIMusixMatch(withData: data, forObject: searchObject) {
                            self.delegate?.updateTableData(self, with: arrayParseSongs)
                        }
                    }
                    else {
                        if let arrayParseSongs = self.parseXMLForSearchInAPIChartLyric(withData: data) {
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
    
    func getLyricOnAPILibrary(withTrack track: TrackData) {
        let id = track.trackId
        var urlString = "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=\(id)&apikey=339038aaacb29db79872b63e7098e129"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: url!) { [weak self] data, response, error in
            if (response as? HTTPURLResponse) != nil {
                if let data = data {
                    if let lyric = self?.parseJSONLyric(withData: data) {
                        track.lyricBody = lyric
                        self?.delegate?.setLyric(self!, with: track)
                    }
                }
            }
            else {
                self?.delegate?.showError(self!)
            }
        }
        task?.resume()
    }
    
    func parseJSONForSearchInAPIMusixMatch(withData data: Data, forObject searchObject: ModelObjectSearch) -> [TrackData]? {
        do {
            print(data)
            let decoder = JSONDecoder()
            let APILyricManager = try decoder.decode(ForSearchInApiMusixMatch.self, from: data)
            let count = APILyricManager.message.body.trackList.count
            print (count)
            var arraySongs = [TrackData]()
            var i: Int = 0
            while i < count {
                let trackList = APILyricManager.message.body.trackList[i]
                let song = TrackData(trackName: trackList.track.trackName, artistName: trackList.track.artistName, trackId: String(trackList.track.trackId), hasLyric: trackList.track.hasLyrics, lyricBody: "", lyricChecksum: "")
                arraySongs.append(song)
                i = i + 1
            }
            return arraySongs
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func parseJSONLyric(withData data: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let APILyricManager = try decoder.decode(APILyricData.self, from: data)
            let lyric = APILyricManager.message.body.lyrics.lyricsBody
            return lyric
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func parseXMLForSearchInAPIChartLyric(withData data: Data) -> [TrackData]? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        print(tracks[4].trackName)
        return tracks
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "SearchLyricResult" {
            lyricChecksum = ""
            artist = ""
            song = ""
            lyricID = 0
            
            if attributeDict["xsi:nil"] == nil {
                self.elementName = elementName
            }
            else {
                self.elementName = "nil"
            }
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "SearchLyricResult" {
            let track = TrackData(trackName: song, artistName: artist, trackId: "", hasLyric: lyricID, lyricBody: "", lyricChecksum: "")
            tracks.append(track)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == "Song" {
                song += data
            }
            else if self.elementName == "LyricId" {
                lyricID += Int(data) ?? 0
            }
            else if self.elementName == "Artist" {
                artist += data
            }
            else if self.elementName == "LyricChecksum" {
                lyricChecksum += data
            }
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        for item in tracks {
//            print (item.trackName)
        }
    }
}
