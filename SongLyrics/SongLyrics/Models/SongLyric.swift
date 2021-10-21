//
//  SongLyric.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.10.2021.
//

import Foundation

class SongLyric: NSObject {
    var songName: String = ""
    var authorName: String = ""
    var lyricBody: String = ""
    init (songName: String, autorName: String, lyricBody: String) {
        self.songName = songName
        self.authorName = autorName
        self.lyricBody = lyricBody
        super.init()
    }
}
