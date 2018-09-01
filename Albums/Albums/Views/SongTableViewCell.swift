//
//  SongTableViewCell.swift
//  Albums
//
//  Created by Linh Bouniol on 8/31/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

protocol SongTableViewCellDelegate: class {
    func addSong(with title: String, duration: String)
}

class SongTableViewCell: UITableViewCell {

    var song: Song? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: SongTableViewCellDelegate?
    
    @IBOutlet weak var songTitleTextField: UITextField!
    @IBOutlet weak var songDurationTextField: UITextField!
    @IBOutlet weak var addSong: UIButton!
    
    @IBAction func addSong(_ sender: Any) {
        guard let title = songTitleTextField.text, let duration = songDurationTextField.text else { return }
        
        delegate?.addSong(with: title, duration: duration)
    }
    
    func updateViews() {
        guard let song = song else {
            addSong.alpha = 1.0
            return }
        
        addSong.alpha = 0.0
            
        songTitleTextField.text = song.title
        songDurationTextField.text = song.duration
    }
    
    override func prepareForReuse() {
        songTitleTextField.text = nil
        songDurationTextField.text = nil
    }
}
