//
//  EpisodeMD.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Foundation

struct EpisodeMD {
    let id: Int
    let name: String
    let airDate: String
    let episode: String
}

// MARK: - Decodable

extension EpisodeMD: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case airDate = "air_date"
        case episode
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(Int.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let airDate = try container.decode(String.self, forKey: .airDate)
        let episode = try container.decode(String.self, forKey: .episode)
        self.init(id: id, name: name, airDate: airDate, episode: episode)
    }
}
