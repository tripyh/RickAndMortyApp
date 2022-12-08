//
//  CharacterManager.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Moya

class CharacterManager {
    private static let provider = MoyaProvider<CharacterService>()
    
    class func characters(params: [String: Any], completionHendler: @escaping([CharacterMD]?, String?) -> Void) {
        provider.request(.characters(params)) { result in
            switch result {
            case .success(let success):
                do {
                    let characterResults = try JSONDecoder().decode(CharacterResultsMD.self, from: success.data)
                    completionHendler(characterResults.results, nil)
                } catch let error {
                    completionHendler(nil, error.localizedDescription)
                }
            case .failure(let error):
                completionHendler(nil, error.localizedDescription)
            }
        }
    }
}
