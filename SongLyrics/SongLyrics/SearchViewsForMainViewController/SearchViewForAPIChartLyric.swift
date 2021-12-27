//
//  SegmentControllerForAPIChartLyric.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.12.2021.
//

import Foundation
import UIKit

protocol SearchViewForAPIChartLyricDelegate: AnyObject {
    func textFieldForArtistChanges (artistName: String?)
    func textFieldForTrackChanges (trackName: String?)
}

class SearchViewForAPIChartLyric: UIView {
    @IBOutlet weak var textFieldForArtist: UITextField!
    @IBOutlet weak var textFieldForTrack: UITextField!
    
    weak var delegate: SearchViewForAPIChartLyricDelegate?
    
    @IBAction func changeTextFieldForArtist(_ sender: Any) {
        delegate?.textFieldForArtistChanges(artistName: textFieldForArtist.text)
    }
    
    @IBAction func changeTextFieldForTrack(_ sender: Any) {
        delegate?.textFieldForTrackChanges(trackName: textFieldForTrack.text)
    }
}
