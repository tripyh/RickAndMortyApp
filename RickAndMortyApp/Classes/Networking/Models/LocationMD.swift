//
//  LocationMD.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Foundation

struct LocationMD {
    let name: String
    let url: String
}

// MARK: - Decodable

extension LocationMD: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case url
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let name = try container.decode(String.self, forKey: .name)
        let url = try container.decode(String.self, forKey: .url)
        self.init(name: name, url: url)
    }
}

