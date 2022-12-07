//
//  CharacterResultsMD.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Foundation

struct CharacterResultsMD {
    let results: [CharacterMD]
}

// MARK: - Decodable

extension CharacterResultsMD: Decodable {
    private enum CodingKeys: String, CodingKey {
        case results
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let results = try container.decode([CharacterMD].self, forKey: .results)
        self.init(results: results)
    }
}
