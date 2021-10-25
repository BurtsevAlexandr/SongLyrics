//
//  ViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 12.10.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, APILyricsManagerDelegate {
    
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var lyricManager = APILyricsManager()
    var songItems = [SongItems]()
    var lyric: String = "ghbd"
    var trackID: Int = 0
    
    func getLyric(_: APILyricsManager, with APIData: String) {
        self.lyric = APIData
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowLyric", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? LyricViewController
        vc?.lyric = lyric
    }
    
    func updateTableData(_: APILyricsManager, with APIData: [SongItems]) {
        songItems = APIData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
            self.lyricManager.getLyricOnAPILibrary(withID: selectedCell.trackId)
        }
    }
    
    @IBAction func search(_ sender: Any) {
        tableView.reloadData()
    }
    
    
    @IBAction func changeTextField(_ sender: Any) {
        if let text = self.searchTextField.text {
            lyricManager.searchInAPILibrary(withWords: text)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.lyricManager.delegate = self
    }
}

