//
//  EpisodeManager.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Moya

class EpisodeManager {
    private static let provider = MoyaProvider<EpisodeService>()
    
    class func episode(_ episode: String, completionHendler: @escaping(EpisodeMD?, String?) -> Void) {
        provider.request(.episode(episode)) { result in
            switch result {
            case .success(let success):
                do {
                    let episode = try JSONDecoder().decode(EpisodeMD.self, from: success.data)
                    completionHendler(episode, nil)
                } catch let error {
                    completionHendler(nil, error.localizedDescription)
                }
            case .failure(let error):
                completionHendler(nil, error.localizedDescription)
            }
        }
    }
}
