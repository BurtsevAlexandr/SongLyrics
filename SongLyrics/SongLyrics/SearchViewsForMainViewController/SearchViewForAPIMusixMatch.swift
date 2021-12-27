//
//  SegmentControllerForAPIMusixMatch.swift
//  SongLyrics
//
//  Created by Alexandr Burtsev on 21.12.2021.
//

import Foundation
import UIKit

protocol SearchViewForAPIMusixMatchDelegate: AnyObject {
    func wordsSearchTextFieldChanges (wordsSearch: String?)
    func atributeSearchChanged ()
}

class SearchViewForAPIMusixMatch: UIView {
    @IBOutlet weak var wordsSearchTextField: UITextField!
    @IBOutlet weak var atributeSearchSegmentController: UISegmentedControl!
   
    weak var delegate: SearchViewForAPIMusixMatchDelegate?
    
    @IBAction func changeWordsSearchTextField(_ sender: Any) {
        delegate?.wordsSearchTextFieldChanges(wordsSearch: wordsSearchTextField.text)
    }
    @IBAction func changeAtributeSearch(_ sender: Any) {
        delegate?.atributeSearchChanged()
    }
}
