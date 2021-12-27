//
//  ViewController.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 12.10.2021.
//

import UIKit

class SongLyricsMainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, XMLParserDelegate {
    
    @IBOutlet weak var searchViewForAPISpace: UIView!
    @IBOutlet weak var segmentControlAPILibrary: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    var tracksList = [TrackData]()
    var track = TrackData(trackName: "", artistName: "", trackId: "", hasLyric: 0, lyricChecksum: "")
    
    var searchViewForAPIMusixMatch: SearchViewForAPIMusixMatch!
    var searchViewForAPIChartLyric: SearchViewForAPIChartLyric!
    
    var searchRequestBuilder: SearchRequestBuilder = .init()
    var apiLyricRepository: APILyricRepository?
    
    private var infoAboutCurrentSearchPage = PageInfo(hasMorePage: true, currentPageNumber: 1)
    private var debouncer: DebouncerAPIRequest!
    private var textFieldValue = "" {
        didSet {
            debouncer.call()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as? LyricViewController
        vc?.track = track
        vc?.apiLyricRepository = apiLyricRepository
    }
    
    //MARK: Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tracksList.count == 0 {
            return 1
        }
        else {
            return tracksList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.allowsSelection = true
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongItem", for: indexPath)
        if tracksList.count == 0 {
            cell.textLabel!.text = "Nothin found"
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
    
    //MARK: Table view delegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.row == tracksList.count - 5 && infoAboutCurrentSearchPage.hasMorePage) {
            searchRequestBuilder.setNextPageSearchRequest()
            performSearch()
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
            track = selectedCell
            self.performSegue(withIdentifier: "ShowLyric", sender: nil)
        }
    }
    
    @IBAction func changedValueSegmentControlAPILibrary(_ sender: Any) {
        installCurrentSearchView()
        makeRequestSearch()
    }
    
    @IBAction func search(_ sender: Any) {
        makeRequestSearch()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debouncer = DebouncerAPIRequest.init(delay: 0.5, callback: debouncerApiCall)
        searchViewForAPIMusixMatch = loadSearchView(ofType: "SearchViewForAPIMusixMatch") as! SearchViewForAPIMusixMatch
        searchViewForAPIChartLyric = loadSearchView(ofType: "SearchViewForAPIChartLyric") as! SearchViewForAPIChartLyric
        searchViewForAPIMusixMatch.delegate = self
        searchViewForAPIChartLyric.delegate = self
        installCurrentSearchView()
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    private func debouncerApiCall() {
        makeRequestSearch()
    }
    
    func makeRequestSearch () {
        searchRequestBuilder.setFirstPageSearchRequest()
        tracksList.removeAll()
        infoAboutCurrentSearchPage = PageInfo(hasMorePage: true, currentPageNumber: 1)
        performSearch()
    }
    
    func performSearch () {
        let searchRequest = searchRequestBuilder.getResult()
    
        apiLyricRepository?.loadingFoundTracks(searchRequest) { [weak self] trackList in
            DispatchQueue.main.async {
                do {
                    let newTrackList = try trackList.get().trackList
                    self!.infoAboutCurrentSearchPage = try trackList.get().pageInfo
                    self!.tracksList += newTrackList
                    self!.tableView.reloadData()
                }
                catch(let error) {
                    print("Failed to get track list with error: \(error)")
                }
            }
        }
        tableView.reloadData()
    }
}

extension SongLyricsMainViewController: SearchViewForAPIMusixMatchDelegate {
    func wordsSearchTextFieldChanges(wordsSearch: String?) {
        textFieldValue = wordsSearch ?? ""
        searchRequestBuilder.setWordsSearch(textFieldValue)
    }
    
    func atributeSearchChanged() {
        switch searchViewForAPIMusixMatch.atributeSearchSegmentController.selectedSegmentIndex {
        case 0:
            apiLyricRepository = MusixMatchMapRepositoryForSearchTrackByName()
        case 1:
            apiLyricRepository = MusixMatchMapRepositoryForSearchTrackByArtist()
        case 2:
            apiLyricRepository = MusixMatchMapRepositoryForSearchTrackByAll()
        default:
            break
        }
    }
}

extension SongLyricsMainViewController: SearchViewForAPIChartLyricDelegate {
    func textFieldForArtistChanges(artistName: String?) {
        searchRequestBuilder.setArtistNameSearch(artistName)
    }
    
    func textFieldForTrackChanges(trackName: String?) {
        searchRequestBuilder.setTrackNameSearch(trackName)
    }
}

private extension SongLyricsMainViewController {
    
    func loadSearchView(ofType viewType: String) -> UIView? {
        Bundle.main.loadNibNamed(viewType,
                                 owner: nil,
                                 options: nil)?.first as? UIView
    }

    func installCurrentSearchView() {
        switch segmentControlAPILibrary.selectedSegmentIndex {
        case 0:
            installSearchView(searchViewForAPIMusixMatch)
            atributeSearchChanged()
        case 1:
            installSearchView(searchViewForAPIChartLyric)
            apiLyricRepository = ChartLyricMapRepositoryForSearchTrackByTrackAndArtist()
        default:
            break
        }
    }

    func installSearchView(_ searchView: UIView) {
        searchViewForAPISpace.subviews.forEach { $0.removeFromSuperview() }

        searchViewForAPISpace.addSubview(searchView)
        
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.leadingAnchor.constraint(equalTo: searchViewForAPISpace.leadingAnchor).isActive = true
        searchView.trailingAnchor.constraint(equalTo: searchViewForAPISpace.trailingAnchor).isActive = true
        searchView.topAnchor.constraint(equalTo: searchViewForAPISpace.topAnchor).isActive = true
        searchView.bottomAnchor.constraint(equalTo: searchViewForAPISpace.bottomAnchor).isActive = true
    }
}
