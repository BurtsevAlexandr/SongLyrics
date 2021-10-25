//
//  LyricViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.10.2021.
//

import Foundation
import UIKit


class LyricViewController: UIViewController {
    
    var track = TrackData(trackName: "", artistName: "", trackId: 0, hasLyric: 0, lyricBody: "Не удалось найти текст")

    @IBOutlet weak var LyricTextView: UITextView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func viewDidLoad() {
        LyricTextView.text = track.lyricBody
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        
        super.viewDidLoad()
        
    }
}
