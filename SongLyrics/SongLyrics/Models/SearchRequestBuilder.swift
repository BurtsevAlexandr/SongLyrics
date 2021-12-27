//
//  SearchRequestBuilder.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 22.12.2021.
//

import Foundation

class SearchRequestBuilder {
    private var wordsSearch: String?
    private var searchNumberPage = 1
    private var trackName: String?
    private var artistName: String?
    private var hasMorePages = true
    
    func setWordsSearch(_ wordsSearch: String?) {
        self.wordsSearch = wordsSearch
        if wordsSearch == "" {
            self.wordsSearch = nil
        }
    }
    
    func setNextPageSearchRequest() {
        self.searchNumberPage += 1
    }
    
    func setFirstPageSearchRequest() {
        self.searchNumberPage = 1
    }
    
    func setTrackNameSearch(_ trackName: String?) {
        self.trackName = trackName
        if trackName == "" {
            self.trackName = nil
        }
    }
    
    func setArtistNameSearch(_ artistName: String?) {
        self.artistName = artistName
        if artistName == "" {
            self.artistName = nil
        }
    }
    
    func getResult() -> SearchRequst {
        SearchRequst(wordsSearch: wordsSearch, searchNumberPage: searchNumberPage, trackName: trackName, artistName: artistName)
    }
}
