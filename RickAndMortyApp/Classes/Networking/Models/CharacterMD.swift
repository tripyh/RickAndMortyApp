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
}

// MARK: - Decodable

extension CharacterMD: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        self.init(id: id, name: name)
    }
}
