//
//  ViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 12.10.2021.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, XMLParserDelegate, APILyricsManagerDelegate {
    
    
    @IBOutlet weak var segmentControlAPILibrary: UISegmentedControl!
    @IBOutlet weak var segmentControlSearchAttributes: UISegmentedControl!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var lyricManager = APILyricsManager()
    var tracksList = [TrackData]()
    var track = TrackData(trackName: "", artistName: "", trackId: "", hasLyric: 0, lyricBody: "", lyricChecksum: "")
    var objectSearch = ModelObjectSearch(markOfSelectedLibrary: "", markOfSearchAttribute: "", artistName: "", trackName: "", wordsSearch: "", searchNumberPage: 1)
    
    let textFieldForTrack = UITextField()
    
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
            self.objectSearch.searchNumberPage! += 1
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
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if objectSearch.markOfSelectedLibrary == "API-MusixMatch" {
            if (indexPath.row == tracksList.count - 5) {
                if searchTextField.text != nil {
                    lyricManager.searchInApiLibrary(for: objectSearch)
                }
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
            lyricManager.getLyricOnAPILibrary(withTrack: selectedCell, for: objectSearch)
        }
    }
    
    
    @IBAction func changedValueSegmentControlSearchAttribetes(_ sender: Any) {
        if segmentControlAPILibrary.selectedSegmentIndex == 0 {
            if segmentControlSearchAttributes.selectedSegmentIndex == 0 {
                objectSearch.markOfSearchAttribute = "Artist"
                searchTextField.placeholder = "Enter the artist of track"
            }
            else if segmentControlSearchAttributes.selectedSegmentIndex == 1 {
                objectSearch.markOfSearchAttribute = "Track"
                searchTextField.placeholder = "Enter the name of track"
            }
            else {
                objectSearch.markOfSearchAttribute = "All"
                searchTextField.placeholder = "Enter the words to search for"
            }
        }
        else {
            if segmentControlSearchAttributes.selectedSegmentIndex == 1 {
                textFieldForTrack.frame.size.width = searchTextField.frame.size.width
                textFieldForTrack.frame.size.height = searchTextField.frame.size.height
                textFieldForTrack.frame.origin.x = searchTextField.frame.origin.x
                textFieldForTrack.frame.origin.y = searchTextField.frame.origin.y + searchTextField.frame.size.height + 10
                textFieldForTrack.borderStyle = searchTextField.borderStyle
                textFieldForTrack.font = searchTextField.font
                textFieldForTrack.placeholder = "Enter the name of track"
                searchTextField.placeholder = "Enter the artist of track"
                tableView.frame.origin.y = textFieldForTrack.frame.origin.y + textFieldForTrack.frame.size.height + 10
                self.view.addSubview(textFieldForTrack)
                objectSearch.markOfSearchAttribute = "Atribute-Artist and track"
            }
            else {
                if textFieldForTrack.superview == self.view.viewWithTag(3)  {
                    tableView.frame.origin.y = searchTextField.frame.origin.y + searchTextField.frame.size.height + 10
                    textFieldForTrack.removeFromSuperview()
                    objectSearch.markOfSearchAttribute = "Atribute-Fragment text lyric"
                    searchTextField.placeholder = "Enter the fragment of text lyric"
                }
            }
        }
    }
    
    @IBAction func changedValueSegmentControlAPILibrary(_ sender: Any) {
        if segmentControlAPILibrary.selectedSegmentIndex == 0 {
            if textFieldForTrack.superview == self.view.viewWithTag(3)  {
                tableView.frame.origin.y = searchTextField.frame.origin.y + searchTextField.frame.size.height + 10
                textFieldForTrack.removeFromSuperview()
            }
            segmentControlSearchAttributes.removeAllSegments()
            segmentControlSearchAttributes.insertSegment(with: .none, at: 0, animated: false)
            segmentControlSearchAttributes.insertSegment(with: .none, at: 1, animated: false)
            segmentControlSearchAttributes.insertSegment(with: .none, at: 2, animated: false)
            segmentControlSearchAttributes.setTitle("Artist", forSegmentAt: 0)
            segmentControlSearchAttributes.setTitle("Track", forSegmentAt: 1)
            segmentControlSearchAttributes.setTitle("All", forSegmentAt: 2)
            segmentControlSearchAttributes.selectedSegmentIndex = 0
            objectSearch.markOfSelectedLibrary = "API-MusixMatch"
            objectSearch.markOfSearchAttribute = "Artist"
            searchTextField.placeholder = "Enter the artist of track"
        }
        else {
            segmentControlSearchAttributes.removeAllSegments()
            segmentControlSearchAttributes.insertSegment(with: .none, at: 0, animated: false)
            segmentControlSearchAttributes.insertSegment(with: .none, at: 1, animated: false)
            segmentControlSearchAttributes.setTitle("Fragment text lyric", forSegmentAt: 0)
            segmentControlSearchAttributes.setTitle("Artist and track", forSegmentAt: 1)
            segmentControlSearchAttributes.selectedSegmentIndex = 0
            objectSearch.markOfSelectedLibrary = "API-ChartLyric"
            objectSearch.markOfSearchAttribute = "Atribute-Fragment text lyric"
            searchTextField.placeholder = "Enter the fragment of text lyric"
        }
    }
    
    @IBAction func search(_ sender: Any) {
        tracksList.removeAll()
        tableView.reloadData()
        objectSearch.wordsSearch = nil
        objectSearch.searchNumberPage = 1
        if objectSearch.markOfSelectedLibrary == "API-MusixMatch" {
            objectSearch.wordsSearch = searchTextField.text
            lyricManager.searchInApiLibrary(for: objectSearch)
        }
        else {
            if objectSearch.markOfSearchAttribute == "Atribute-Fragment text lyric" {
                objectSearch.wordsSearch = searchTextField.text
                lyricManager.searchInApiLibrary(for: objectSearch)
            }
            else {
                if textFieldForTrack.text != nil && textFieldForTrack.text != "" && searchTextField.text != nil && searchTextField.text != "" {
                    objectSearch.trackName = textFieldForTrack.text
                    objectSearch.artistName = searchTextField.text
                    lyricManager.searchInApiLibrary(for: objectSearch)
                }
            }
        }
    }
    
    @IBAction func changeTextField(_ sender: Any) {
        tracksList.removeAll()
        tableView.reloadData()
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.top, animated: true)
        objectSearch.searchNumberPage = 1
        if objectSearch.markOfSelectedLibrary == "API-MusixMatch" {
            objectSearch.wordsSearch = (sender as? UITextField)?.text ?? ""
            textFieldValue = objectSearch.wordsSearch ?? ""
        }
        else {
            if objectSearch.markOfSearchAttribute == "Atribute-Fragment text lyric" {
                objectSearch.wordsSearch = (sender as? UITextField)?.text ?? ""
                textFieldValue = objectSearch.wordsSearch ?? ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentControlAPILibrary.selectedSegmentIndex = 0
        segmentControlSearchAttributes.selectedSegmentIndex = 0
        objectSearch.markOfSelectedLibrary = "API-MusixMatch"
        objectSearch.markOfSearchAttribute = "Artist"
        searchTextField.placeholder = "Enter the artist of track"
        debouncer = Debouncer.init(delay: 0.5, callback: debouncerApiCall)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.lyricManager.delegate = self
    }
    
    private func debouncerApiCall() {
        lyricManager.searchInApiLibrary(for: objectSearch)
    }
}

