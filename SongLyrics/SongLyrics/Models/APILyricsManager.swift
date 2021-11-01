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

class APILyricsManager {
    
    weak var delegate: APILyricsManagerDelegate?
    var task: URLSessionDataTask?
    
    func searchInAPILibrary(with words: String, with page: Int) {
        var urlString = "https://api.musixmatch.com/ws/1.1/track.search?q_track_artist=\(words)&page_size=30&page=\(page)&apikey=339038aaacb29db79872b63e7098e129"
        urlString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        let session = URLSession(configuration: .default)
        task?.cancel()
        task = session.dataTask(with: url!) { [self] data, response, error in
            if response != nil {
                if let data = data {
                    if let arrayParseSongs = self.parseJSON(withData: data) {
                        self.delegate?.updateTableData(self, with: arrayParseSongs)
                    }
                }
            }
            else {
                if error == nil {
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
    
    func parseJSON(withData data: Data) -> [TrackData]? {
        let decoder = JSONDecoder()
        do {
            let APILyricManager = try decoder.decode(APITracksData.self, from: data)
            let count = APILyricManager.message.body.trackList.count
            var arraySongs = [TrackData]()
            
            var i: Int = 0
            while i < count {
                let trackList = APILyricManager.message.body.trackList[i]
                let song = TrackData(trackName: trackList.track.trackName, artistName: trackList.track.artistName, trackId: trackList.track.trackId, hasLyric: trackList.track.hasLyrics, lyricBody: "")
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
