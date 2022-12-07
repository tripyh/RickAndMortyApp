//
//  Config+server.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Foundation

struct Config {
    static let serverBaseURL: URL = {
        return URL(string: "https://rickandmortyapi.com/api/")!
    }()
}
