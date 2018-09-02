//
//  AlbumsTableViewController.swift
//  Albums
//
//  Created by Linh Bouniol on 8/31/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UITableViewController {
    
    var albumController = AlbumController()

    override func viewDidLoad() {
        super.viewDidLoad()

        albumController.getAlbums(completion: { (error) in
            if let error = error {
                NSLog("Error getting album data from server: \(error)")
                return
            }
            self.tableView.reloadData()
        })
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumController.albums.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath)

        let album = albumController.albums[indexPath.row]
        cell.textLabel?.text = album.name
        cell.detailTextLabel?.text = album.artist

        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? AlbumDetailTableViewController {
            detailVC.albumController = albumController
            
            if segue.identifier == "ShowAlbumDetail" {
                
                guard let index = tableView.indexPathForSelectedRow?.row else { return }
                let album = albumController.albums[index]
                detailVC.album = album
            }
        }
    }
}
