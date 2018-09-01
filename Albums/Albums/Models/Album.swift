//
//  Album.swift
//  Albums
//
//  Created by Linh Bouniol on 8/31/18.
//  Copyright © 2018 Linh Bouniol. All rights reserved.
//

import Foundation

struct Album: Codable {
    
    let name: String
    let artist: String
    let id: String
    let genres: [String]
    let coverArt: [URL]
    let songs: [Song]
    
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
        self.coverArt = coverArt
    }
    
}
