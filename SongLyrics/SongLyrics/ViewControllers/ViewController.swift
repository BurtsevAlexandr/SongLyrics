//
//  ViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 12.10.2021.
//

import UIKit

protocol ViewControllerDelegate: class {
    func showLyric (_: ViewController, with Lyric: String)
}

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, APILyricsManagerDelegate {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ViewControllerDelegate?
    var lyricManager = APILyricsManager()
    var songItems = [SongItems]()
    var lyric: String = ""
    
    func getLyric(_: APILyricsManager, with APIData: String) {
        lyric = APIData
        self.delegate?.showLyric(self, with: lyric)
    }
    
    func updateTableData(_: APILyricsManager, with APIData: [SongItems]) {
        songItems = APIData
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.allowsSelection = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongItem", for: indexPath)
        let songsList = songItems[indexPath.row]
        cell.textLabel!.text = songsList.songName
        cell.detailTextLabel!.text = songsList.authorName
        if (songsList.hasSong == 0) {
            cell.accessoryType = .none
        }
        else {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = songItems[indexPath.row]
        
        if (selectedCell.hasSong == 0) {
            let alert = UIAlertController (title: title, message: "You score:" ,preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default, handler: .none)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else {
            
            let trackID = selectedCell.trackId
            lyricManager.getLyricOnAPILibrary(withID: trackID)
//            self.delegate?.showLyric(self, with: lyric)
            performSegue(withIdentifier: "ShowLyric", sender: .none )

        }
    }
    
    @IBAction func search(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func changeTextField(_ sender: Any) {
        if let text = searchTextField.text {
            lyricManager.searchInAPILibrary(withWords: text)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.lyricManager.delegate = self
    }
}

