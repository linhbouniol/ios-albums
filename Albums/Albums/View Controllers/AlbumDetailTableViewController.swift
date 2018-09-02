//
//  AlbumDetailTableViewController.swift
//  Albums
//
//  Created by Linh Bouniol on 8/31/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class AlbumDetailTableViewController: UITableViewController, SongTableViewCellDelegate {
    
    var albumController: AlbumController?
    
    var album: Album? {
        didSet {
            updateViews()
        }
    }
    
    // Temporarily hold on to songs the user adds until they tap save button
    var tempSongs = [Song]()
    
    // MARK: - Outlets/Actions
    
    @IBOutlet weak var albumNameTextField: UITextField!
    @IBOutlet weak var artistTextField: UITextField!
    @IBOutlet weak var genresTextField: UITextField!
    @IBOutlet weak var coverURLsTextField: UITextField!
    
    @IBAction func save(_ sender: Any) {
        guard let name = albumNameTextField.text, let artist = artistTextField.text, let genresString = genresTextField.text, let coverURLsString = coverURLsTextField.text else { return }
        
        let genresArray = genresString.components(separatedBy: ", ")
        
        let coverArtStringArray = coverURLsString.components(separatedBy: ", ")
//        let coverArtOptionalURLsArray = coverArtStringArray.map({ URL(string: $0) })
//        let nonNilURLsArray = coverArtOptionalURLsArray.filter({ $0 != nil })
//        let coverArtURLsArray = nonNilURLsArray.map({ $0! })
        
        var coverArtURLsArray = [URL]()
        
        for urlString in coverArtStringArray {
            
            // if url is invalid, step to next check
            guard let url = URL(string: urlString) else { continue }
            
            coverArtURLsArray.append(url)
        }
        
        if let album = album {
            albumController?.update(album: album, name: name, artist: artist, genres: genresArray, coverArt: coverArtURLsArray, songs: tempSongs, completion: { (error) in
                if let error = error {
                    NSLog("Error saving albums: \(error)")
                }
            })
        } else {
            albumController?.createAlbum(withName: name, artist: artist, genres: genresArray, coverArt: coverArtURLsArray, songs: tempSongs, completion: { (error) in
                if let error = error {
                    NSLog("Error creating albums: \(error)")
                }
            })
        }
        
        // Set this here, that way the VC pop either way
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - SongTableViewCellDelegate
    
    func addSong(with title: String, duration: String) {
        
        guard let song = albumController?.createSong(withTitle: title, duration: duration) else { return }
        
        tempSongs.append(song)
        
        tableView.reloadData()
        
        let indexPath = IndexPath(row: tempSongs.count, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
    }

    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Methods
    
    func updateViews() {
        // Make sure view is loaded before setting the values of outlets or app will crash
        guard isViewLoaded else { return }
        
        if let album = album {
            self.title = album.name
            
            albumNameTextField.text = album.name
            artistTextField.text = album.artist
            genresTextField.text = album.genres.joined(separator: ", ")
            
            let urlStringArray = album.coverArt.map({ $0.absoluteString })
            coverURLsTextField.text = urlStringArray.joined(separator: ", ")
            
            tempSongs = album.songs
        } else {
            self.title = "New Album"
        }
    }

    // MARK: - TableViewDataSource

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tempSongs.count + 1  // number of cells (5 songs, 1 new song)
            // + 1 allows there to be an empty cell for the user to add a new song to
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SongCell", for: indexPath) as! SongTableViewCell

        if indexPath.row < tempSongs.count {
            cell.song = tempSongs[indexPath.row]
        } else {
            cell.song = nil
        }
        cell.delegate = self

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < tempSongs.count {
            return 100.0
        } else {
            return 140.0
        }
    }
    
}
