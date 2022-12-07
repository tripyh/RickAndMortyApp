//
//  CharacterMD.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Foundation

struct CharacterMD {
    let id: Int
    let name: String
    let status: String
    let image: String
    let location: LocationMD
}

// MARK: - Decodable

extension CharacterMD: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case status
        case image
        case location
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let status = try container.decode(String.self, forKey: .status)
        let image = try container.decode(String.self, forKey: .image)
        let location = try container.decode(LocationMD.self, forKey: .location)
        self.init(id: id, name: name, status: status, image: image, location: location)
    }
}
