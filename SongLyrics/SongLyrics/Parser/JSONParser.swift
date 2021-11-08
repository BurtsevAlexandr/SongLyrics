//
//  JSONParser.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 08.11.2021.
//

import Foundation

class JSONParser {
    func parseJSONForSearchInAPIMusixMatch(withData data: Data) -> [TrackData]? {
        do {
            let decoder = JSONDecoder()
            let APILyricManager = try decoder.decode(ForSearchInApiMusixMatch.self, from: data)
            let count = APILyricManager.message.body.trackList.count
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

    func parseJSONForGetLyricInApiMusixMatch(withData data: Data) -> String? {
        let decoder = JSONDecoder()
        do {
            let APILyricManager = try decoder.decode(ForGetLyricInApiMusixMatch.self, from: data)
            let lyric = APILyricManager.message.body.lyrics.lyricsBody
            return lyric
        }
        catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
    }
}
