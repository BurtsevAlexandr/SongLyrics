//
//  XMLParserForGetLyric.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 08.11.2021.
//

import Foundation

class XMLParserForGetLyric: NSObject, XMLParserDelegate {

    var elementName: String = String()
    var lyric: String = ""
    
    func parseXMLForGetLyricInAPIChartLyric(withData data: Data) -> String? {
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return lyric
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "GetLyricResult" {
           lyric = ""
        }
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "GetLyricResult" {
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if self.elementName == "Lyric" {
                lyric += data
            }
        }
    }
}
