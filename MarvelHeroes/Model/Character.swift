//
//  Character.swift
//  MarvelHeroes
//
//  Created by Filip Krzyzanowski on 17/11/2019.
//  Copyright © 2019 Filip Krzyzanowski. All rights reserved.
//

import Foundation

struct Response: Decodable {
    var data: CharacterData
}

struct CharacterData: Decodable {
    var results: [Character]
}

class Character: Decodable {
    var id: Int
    var name: String
    var description: String
    var thumbnail: Thumbnail
}

struct Thumbnail: Decodable {
    var path: String
    var ext: String
    
    private enum CodingKeys : String, CodingKey {
        case path = "path"
        case ext = "extension"
    }
}
