//
//  AlbumController.swift
//  Albums
//
//  Created by Linh Bouniol on 9/1/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

class AlbumController {
    
    func testDecodingExampleAlbum() {
        
        guard let url = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            print("URL is bad")
            return
        }
        
        do {
            let exampleData = try Data(contentsOf: url)
            
            let album = try JSONDecoder().decode(Album.self, from: exampleData)
            
            print("Success")
        } catch {
            NSLog("Error getting data or decoding data: \(error)")
        }
    }
}
