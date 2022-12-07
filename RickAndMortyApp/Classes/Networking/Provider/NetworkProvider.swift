//
//  NetworkProvider.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Moya
import ReactiveSwift

protocol NetworkTarget: TargetType {
    
}

extension NetworkTarget {
    var baseURL: URL {
        return Config.serverBaseURL
    }
    
    var task: Task {
        return .requestPlain
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String: String]? {
        return [:]
    }
}
