//
//  SongItems.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 13.10.2021.
//

import Foundation
class SongItems: NSObject {
    var songName: String = ""
    var authorName: String = ""
    var trackId: Int = 0
    var hasSong: Int = 0
    init (songName: String, autorName: String, trackId: Int, hasSong: Int) {
        self.songName = songName
        self.authorName = autorName
        self.trackId = trackId
        self.hasSong = hasSong
        super.init()
    }
}
