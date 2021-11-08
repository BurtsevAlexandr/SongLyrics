//
//  APILyric.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.10.2021.
//


import Foundation

struct ForGetLyricInApiMusixMatch: Decodable {
    let message: Message1
}

struct Message1: Decodable {
    let body: Body1
}

struct Body1: Decodable {
    let lyrics: Lyrics
}

struct Lyrics: Decodable {
    let lyricsBody: String
    
    enum CodingKeys: String, CodingKey {
        case lyricsBody = "lyrics_body"
    }
}
