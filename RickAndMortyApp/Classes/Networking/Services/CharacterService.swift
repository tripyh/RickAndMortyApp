//
//  CharacterService.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Moya

enum CharacterService: NetworkTarget {
    case characters(_ page: Int)
    
    var path: String {
        return "character"
    }
    
    var method: Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case let .characters(page):
            return .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
        }
    }
}
