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
    var tracksList = [TrackData]()
    var track = TrackData(trackName: "", artistName: "", trackId: 0, hasLyric: 0, lyricBody: "")
        
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? LyricViewController
        vc?.track = track
    }
    //MARK: API Lyric Manager delegates
    func updateTableData(_: APILyricsManager, with APIData: [TrackData]) {
        tracksList = APIData
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func getLyric(_: APILyricsManager, with APIData: TrackData) {
        self.track = APIData
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowLyric", sender: nil)
        }
    }
    
    //MARK: Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchTextField.text == "" || searchTextField.text == nil {
            return 1
        }
        else {
            if tracksList.count == 0 {
                return 1
            }
            else {
                return tracksList.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.allowsSelection = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongItem", for: indexPath)
        
        if searchTextField.text == nil || searchTextField.text == "" {
            cell.textLabel!.text = "Enter the words to search for"
            cell.detailTextLabel!.text = .none
            cell.accessoryType = .none
            tableView.allowsSelection = false
//            cell.layer.borderColor = .none
            return cell
        }
        else {
            if tracksList.count == 0 {
                cell.textLabel!.text = "Nothing found!"
                cell.detailTextLabel!.text = .none
                cell.accessoryType = .none
                tableView.allowsSelection = false
//                cell.layer.borderColor = .none
                return cell
            }
            else {
                let songsList = tracksList[indexPath.row]
                cell.textLabel!.text = songsList.trackName
                cell.detailTextLabel!.text = songsList.artistName
                if (songsList.hasLyric == 0) {
                    cell.accessoryType = .none
                }
                else {
                    cell.accessoryType = .checkmark
                }
                cell.selectionStyle = .default
                return cell
            }
        }
    }
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tracksList[indexPath.row]
        
        if (selectedCell.hasLyric == 0) {
            let alert = UIAlertController (title: title, message: "Sorry, this track hasn't lyric" ,preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default, handler: .none)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else {
            lyricManager.getLyricOnAPILibrary(withTrack: selectedCell)
        }
    }
    
    
    @IBAction func search(_ sender: Any) {
        if let text = self.searchTextField.text {
            lyricManager.searchInAPILibrary(withWords: text)
        }
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

