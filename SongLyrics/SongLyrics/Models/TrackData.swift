//
//  SongItems.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 13.10.2021.
//

import Foundation
class TrackData: NSObject {
    var trackName: String = ""
    var artistName: String = ""
    var trackId: Int = 0
    var hasLyric: Int = 0
    var lyricBody: String = ""
    init (trackName: String, artistName: String, trackId: Int, hasLyric: Int, lyricBody: String?) {
        self.trackName = trackName
        self.artistName = artistName
        self.trackId = trackId
        self.hasLyric = hasLyric
        self.lyricBody = lyricBody ?? ""
        super.init()
    }
}
