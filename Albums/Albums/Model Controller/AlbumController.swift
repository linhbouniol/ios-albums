//
//  AlbumController.swift
//  Albums
//
//  Created by Linh Bouniol on 9/1/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

class AlbumController {
    
    var albums = [Album]()
    
    // For testing...
    func testDecodingExampleAlbum() {
        
        guard let url = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            print("URL is bad")
            return
        }
        
        do {
            // this could be slow if there are a lot of data to decode
            let exampleData = try Data(contentsOf: url)
            
            // decoding and encoding could also be slow
            _ = try JSONDecoder().decode(Album.self, from: exampleData)
            
            print("Success")
        } catch {
            NSLog("Error getting data or decoding data: \(error)")
        }
    }
    
    func testEncodingExampleAlbum() {
        
        guard let url = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
            print("URL is bad")
            return
        }
        
        do {
            let exampleData = try Data(contentsOf: url)
            
            let album = try JSONDecoder().decode(Album.self, from: exampleData)
            print("Success decoding")
            
            do {
                let _ = try JSONEncoder().encode(album)
                print("Success encoding")
            } catch {
                NSLog("Error getting data or encoding data: \(error)")
            }
            
        } catch {
            NSLog("Error getting data or decoding data: \(error)")
        }
    }
    
//    func loadFromFile(completion: @escaping (Error?) -> Void) {
//        // Create a new dispatch queue
//        let myDispatchQueue = DispatchQueue(label: "myDispatchQueue")
//
//        myDispatchQueue.async {
//
//            print("Before sleep (simulating a slow loading procress)")
//            sleep(10)
//            print("After sleep")
//
//            guard let url = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else {
//                print("URL is bad")
//                DispatchQueue.main.async {
//                    completion(NSError())   // going back to main queue to report any issues
//                }
//                return
//            }
//
//            do {
//                let exampleData = try Data(contentsOf: url)
//
//                let album = try JSONDecoder().decode(Album.self, from: exampleData)
//
//                DispatchQueue.main.async {
//                    print(album)
//                    completion(nil)
//                }
//
//                print("Success")
//            } catch {
//                NSLog("Error getting data or decoding data: \(error)")
//                DispatchQueue.main.async {
//                    completion(error)
//                }
//            }
//        }
//    }
    
    static let baseURL = URL(string: "https://albums-458a3.firebaseio.com/")!
    
    func getAlbums(completion: @escaping (Error?) -> Void) {
        
        let url = AlbumController.baseURL.appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error getting data from server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(NSError())
                }
                return
            }
            
            do {
                let decodedAlbums = try JSONDecoder().decode([String: Album].self, from: data)
                let albums = decodedAlbums.map { $0.value }
                DispatchQueue.main.async {
                    self.albums = albums
                    completion(nil)
                }
            } catch {
                NSLog("Error decoding received data: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
            }
        }.resume()
    }
    
    func put(album: Album, completion: @escaping (Error?) -> Void) {
        
        let url = AlbumController.baseURL.appendingPathComponent(album.id).appendingPathExtension("json")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            request.httpBody = try JSONEncoder().encode(album)
        } catch {
            NSLog("Unable to encode \(album): \(error)")
            completion(error)
            return // if there is an error, we want to return out and don't do anything else
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                NSLog("Error saving album to server: \(error)")
                DispatchQueue.main.async {
                    completion(error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil)
            }
        }.resume()
        
        
    }
}
