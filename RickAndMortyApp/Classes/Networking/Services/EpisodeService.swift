//
//  EpisodeService.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Moya

enum EpisodeService: NetworkTarget {
    case episode(_ episode: String)
    
    var baseURL: URL {
        switch self {
        case let .episode(episode):
            return URL(string: episode)!
        }
    }
    
    var path: String {
        return ""
    }
    
    var method: Method {
        return .get
    }
}
