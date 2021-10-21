//
//  APILyricsManager.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 14.10.2021.
//

import Foundation

protocol APILyricsManagerDelegate: class {
    func updateTableData(_: APILyricsManager, with APIData: [SongItems])
    func getLyric(_: APILyricsManager, with APIData: String)
}

class APILyricsManager {
    
    weak var delegate: APILyricsManagerDelegate?
    
    func searchInAPILibrary(withWords words: String) {
        var urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_track_artist=\(words)&apikey=339038aaacb29db79872b63e7098e129"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { [self] data, response, error in
            if let data = data {
                if let arrayParseSongs = self.parseJSON(withData: data) {
                
                    self.delegate?.updateTableData(self, with: arrayParseSongs)
                }
            }
        }
        task.resume()
    }
    
    func getLyricOnAPILibrary(withID id: Int) {
        var urlString = "https://api.musixmatch.com/ws/1.1/track.lyrics.get?track_id=\(id)&apikey=339038aaacb29db79872b63e7098e129"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url!) { [self] data, response, error in
            if let data = data {
                if let lyric = self.parseJSONLyric(withData: data) {
                    
                    self.delegate?.getLyric(self, with: lyric)
                }
            }
        }
        task.resume()
    }
    
    func parseJSON(withData data: Data) -> [SongItems]? {
        let decoder = JSONDecoder()
        do {
            let APILyricManager = try decoder.decode(APILyricsData.self, from: data)
            let count = APILyricManager.message.body.trackList.count
            var arraySongs = [SongItems]()
            
            var i: Int = 0
            while i < count {
                let trackList = APILyricManager.message.body.trackList[i]
                let nameSong = trackList.track.trackName
                let nameArtist = trackList.track.artistName
                let trackId = trackList.track.trackId
                let hasLyrics = trackList.track.hasLyrics
                let song = SongItems(songName: nameSong, autorName: nameArtist, trackId: trackId, hasSong: hasLyrics)
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
}
