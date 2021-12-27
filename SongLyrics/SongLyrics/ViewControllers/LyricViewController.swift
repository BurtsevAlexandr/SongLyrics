//
//  LyricViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.10.2021.
//

import Foundation
import UIKit


class LyricViewController: UIViewController {
    var track = TrackData(trackName: "", artistName: "", trackId: "", hasLyric: 0, lyricChecksum: "")
    var apiLyricRepository: APILyricRepository?
    
    @IBOutlet weak var lyricTextView: UITextView!
    @IBOutlet weak var trackNameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    
    override func viewDidLoad() {
        trackNameLabel.text = track.trackName
        artistNameLabel.text = track.artistName
        apiLyricRepository?.loadingLyric(track) { [weak self] lyric in
            DispatchQueue.main.async {
                do {
                    self!.lyricTextView.text = try lyric.get()
                }
                catch(let error) {
                    print("Failed to get lyric with error: \(error)")
                }
            }
        }
        super.viewDidLoad()
        
    }
}
