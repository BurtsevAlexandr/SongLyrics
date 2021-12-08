//
//  EnumCollections.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 08.12.2021.
//

import Foundation

enum ListAPI {
    case musixMatch
    case chartLyric
}

enum ListSearchAtributes {
    case artistAndTrack
    case fragmentTextLyric
    case artist
    case track
    case all
}

enum ListMessages: String {
    case notFindLyric = "Sorry, this track hasn't lyric"
    case notFindTrack = "Nothing found!"
    case notTextRequst = "Enter the words to search for"
    case notTextRequstForArtistAndTrack = "Both fields must be filled in"
    case errorLoadingLyric = "Сouldn't find the lyric"
}
