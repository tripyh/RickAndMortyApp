//
//  MainViewModel.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Foundation

class MainViewModel {
    
}

// MARK: - Public

extension MainViewModel {
    func getCharacters() {
        CharacterManager.characters(page: 2) { characters, error in
            
        }
    }
}
