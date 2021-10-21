//
//  CurrentLyricsData.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 18.10.2021.
//

import Foundation

struct APILyricsData: Decodable {
    let message: Message
}

struct Message: Decodable {
    let body: Body
}

struct Body: Decodable {
    let trackList: [TrackList]
    
    enum CodingKeys: String, CodingKey {
        case trackList = "track_list"
    }
}

struct TrackList: Decodable {
    let track: Track
}

struct Track: Decodable {
    let artistName: String
    let trackId: Int
    let trackName: String
    let hasLyrics: Int
    
    enum CodingKeys: String, CodingKey {
        case artistName = "artist_name"
        case trackId = "track_id"
        case trackName = "track_name"
        case hasLyrics = "has_lyrics"
    }
}
