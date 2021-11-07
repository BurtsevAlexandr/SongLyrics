//
//  modelObjectSearch.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 03.11.2021.
//

import Foundation

class ModelObjectSearch {
    var markOfSelectedLibrary: String?
    var markOfSearchAttribute: String?
    var artistName: String?
    var trackName: String?
    var wordsSearch: String?
    var searchNumberPage: Int?
    init(markOfSelectedLibrary: String?, markOfSearchAttribute: String?, artistName: String?, trackName: String?, wordsSearch: String?, searchNumberPage: Int?) {
        self.markOfSelectedLibrary = markOfSelectedLibrary
        self.markOfSearchAttribute = markOfSearchAttribute
        self.artistName = artistName
        self.trackName = trackName
        self.wordsSearch = wordsSearch
        self.searchNumberPage = searchNumberPage
    }
}
