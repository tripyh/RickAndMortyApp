//
//  CharacterService.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Moya

enum CharacterService: NetworkTarget {
    case characters(_ params: [String: Any])
    
    var path: String {
        return "character"
    }
    
    var method: Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case let .characters(params):
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
