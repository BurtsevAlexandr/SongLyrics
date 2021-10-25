//
//  LyricViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.10.2021.
//

import Foundation
import UIKit


class LyricViewController: UIViewController {
    var lyric: String = ""

    @IBOutlet weak var LyricTextView: UITextView!
    
    override func viewDidLoad() {
        LyricTextView.text = lyric
        super.viewDidLoad()
        
    }
}
