//
//  LyricViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.10.2021.
//

import Foundation
import UIKit


class LyricViewController: UIViewController, QueryManagerDelegateForGetLyric {
    var apiManager = QueryManagerForAPI()
    var track = TrackData(trackName: "", artistName: "", trackId: "", hasLyric: 0, lyricBody: "Сouldn't find the lyric", lyricChecksum: "")
    var objectSearch = ModelObjectSearch(markOfSelectedLibrary: ListAPI.musixMatch, markOfSearchAttribute: ListSearchAtributes.track, artistName: "", trackName: "", wordsSearch: "", searchNumberPage: 1)
    

    @IBOutlet weak var lyricTextView: UITextView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    func showError(_: QueryManagerForAPI) {
        DispatchQueue.main.async {
            let alert = UIAlertController (title: "Connection error", message: "Unable to contact server. Please check you internet connection or try again later!" ,preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default, handler: .none)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func setLyric(_: QueryManagerForAPI, with APIData: TrackData) {
        DispatchQueue.main.async {
            self.lyricTextView.text = self.track.lyricBody
        }
    }
    
    override func viewDidLoad() {
        self.apiManager.delegateGetLyric = self
        apiManager.getLyricOnAPILibrary(withTrack: track, for: objectSearch)
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        
        super.viewDidLoad()
        
    }
}
