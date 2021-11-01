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
    var searchNumberPage: Int = 1
//    var checkLoad: Int = 1
    
    private var debouncer: Debouncer!
    private var textFieldValue = "" {
        didSet {
            debouncer.call()
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? LyricViewController
        vc?.track = track
    }
    //MARK: API Lyric Manager delegates
    func updateTableData(_: APILyricsManager, with APIData: [TrackData]) {
        tracksList = tracksList + APIData
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.searchNumberPage += 1
//            self.checkLoad = self.searchNumberPage
        }
    }
    
    func setLyric(_: APILyricsManager, with APIData: TrackData) {
        self.track = APIData
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "ShowLyric", sender: nil)
        }
    }
    
    func showError(_: APILyricsManager) {
        DispatchQueue.main.async {
            let alert = UIAlertController (title: "Connection error", message: "Unable to contact server. Please check you internet connection or try again later!" ,preferredStyle: .alert)
            let action = UIAlertAction (title: "OK", style: .default, handler: .none)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
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
            return cell
        }
        else {
            if tracksList.count == 0 {
                cell.textLabel!.text = "Nothing found!"
                cell.detailTextLabel!.text = .none
                cell.accessoryType = .none
                tableView.allowsSelection = false
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
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (tableView.contentSize.height - 800 < tableView.contentOffset.y && searchNumberPage == checkLoad) {
//            checkLoad += 1
//            lyricManager.searchInAPILibrary(with: textFieldValue, with: searchNumberPage)
//        }
//    }
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == tracksList.count - 5) {
            if let text = searchTextField.text {
                lyricManager.searchInAPILibrary(with: text, with: searchNumberPage)
            }
        }
    }
    
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
        tracksList.removeAll()
        if let text = self.searchTextField.text {
            if (text != "") {
                lyricManager.searchInAPILibrary(with: text, with: searchNumberPage)
                tableView.reloadData()
            }
        }
    }
    
    @IBAction func changeTextField(_ sender: Any) {
        tracksList.removeAll()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        searchNumberPage = 1
        textFieldValue = (sender as? UITextField)?.text ?? ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debouncer = Debouncer.init(delay: 0.5, callback: debouncerApiCall)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.lyricManager.delegate = self
    }
    
    private func debouncerApiCall() {
        if let text = self.searchTextField.text {
            lyricManager.searchInAPILibrary(with: text, with: searchNumberPage)
        }
    }
}

