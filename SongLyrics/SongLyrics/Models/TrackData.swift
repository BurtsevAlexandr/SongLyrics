//
//  SongItems.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 13.10.2021.
//

import Foundation
class TrackData: NSObject {
    var trackName: String
    var artistName: String
    var trackId: String
    var hasLyric: Int
    var lyricBody: String
    var lyricChecksum: String
    init (trackName: String, artistName: String, trackId: String, hasLyric: Int, lyricBody: String?, lyricChecksum: String) {
        self.trackName = trackName
        self.artistName = artistName
        self.trackId = trackId
        self.hasLyric = hasLyric
        self.lyricBody = lyricBody ?? ""
        self.lyricChecksum = lyricChecksum
        super.init()
    }
}
