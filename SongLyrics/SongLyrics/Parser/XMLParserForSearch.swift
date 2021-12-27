//
//  XMLParser.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 08.11.2021.
//

import Foundation

class XMLParserForSearch: NSObject, XMLParserDelegate {
    
    var tracks = [TrackData]()
    var elementName = String()
    var song = String()
    var lyricID = Int()
    var artist = String()
    var lyricChecksum = String()
    var checker = 0
    
    func parseXMLForSearchInAPIChartLyric(withData data: Data) -> [TrackData]? {
        tracks.removeAll()
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return tracks
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "SearchLyricResult" {
            lyricChecksum = ""
            artist = ""
            song = ""
            lyricID = 0
            checker = 0
            
            if attributeDict["xsi:nil"] == nil {
                checker = 0
            }
            else {
                checker = 1
            }
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "SearchLyricResult" {
            if checker == 0 {
                let track = TrackData(trackName: song, artistName: artist, trackId: "", hasLyric: lyricID, lyricChecksum: lyricChecksum)
                tracks.append(track)
            }
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
}
