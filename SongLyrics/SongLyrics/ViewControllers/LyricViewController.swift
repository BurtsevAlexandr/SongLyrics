//
//  LyricViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.10.2021.
//

import Foundation
import UIKit


class LyricViewController: UIViewController, ViewControllerDelegate {
    
    
    @IBOutlet weak var LyricTextView: UITextView!
    
    var viewController = ViewController()
    var lyricBody: String = "gbpltw"
    
    func showLyric(_: ViewController, with Lyric: String) {
        lyricBody = Lyric
        print(lyricBody)
        LyricTextView.text = lyricBody
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewController.delegate = self
    }
}
