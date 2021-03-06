//
//  Album.swift
//  Albums
//
//  Created by Linh Bouniol on 8/31/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

struct Album: Codable, Equatable {
    
    var name: String
    var artist: String
    var id: String
    var genres: [String]
    var coverArt: [URL]
    var songs: [Song]
    
    init(name: String, artist: String, genres: [String], coverArt: [URL], songs: [Song]) {
        self.name = name
        self.artist = artist
        self.genres = genres
        self.coverArt = coverArt
        self.songs = songs
        
        self.id = UUID().uuidString
        
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case artist
        case id
        case genres
        case coverArt
        case songs
        
        enum CoverArtCodingKeys: String, CodingKey {
            case url
        }
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // These would have been decoded automatically, if there was no coverArt.
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.id = try container.decode(String.self, forKey: .id)
        self.genres = try container.decode([String].self, forKey: .genres)
        self.songs = try container.decode([Song].self, forKey: .songs)
        
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverArt)
        
        var coverArt = [URL]()
        
        while !coverArtContainer.isAtEnd {
            let urlContainer = try coverArtContainer.nestedContainer(keyedBy: CodingKeys.CoverArtCodingKeys.self)
            
            let urlString = try urlContainer.decode(String.self, forKey: .url)
            
            // if this string is not a url, then you continue to the next url, return will not work here, b/c you need to return something back since we're in an init(). Throw would be better but more complicated to set up.
            guard let url = URL(string: urlString) else { continue }
            
            coverArt.append(url)
        }
        
//        self.name = name
//        self.artist = artist
//        self.id = id
//        self.genres = genres // keep as array here, join with commas in the VC
//        self.songs = songs
        self.coverArt = coverArt // still array here
    }
    
    func encode(to encoder: Encoder) throws {
        
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(artist, forKey: .artist)
        try container.encode(id, forKey: .id)
        try container.encode(genres, forKey: .genres)
        try container.encode(songs, forKey: .songs)
        
        var coverArtContainer = container.nestedUnkeyedContainer(forKey: .coverArt)
        
        for url in coverArt {
            let urlString = url.absoluteString
            
            var urlContainer = coverArtContainer.nestedContainer(keyedBy: CodingKeys.CoverArtCodingKeys.self)
            try urlContainer.encode(urlString, forKey: .url)
        }
    }
}
