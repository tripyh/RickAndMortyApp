//
//  MainViewModel.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import ReactiveCocoa
import ReactiveSwift

class MainViewModel {
    
    // MARK: - Public properties
    
    let reload: Signal<(), Never>
    let showError: Signal<String, Never>
    var loading: Property<Bool> { return Property(_loading) }
    
    // MARK: - Private properties
    
    private let reloadObserver: Signal<(), Never>.Observer
    private let showErrorObserver: Signal<String, Never>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    
    private var characters = [CharacterMD]()
    private let countOnPage = 20
    private var finalPage = false
    private var page = 1
    
    // MARK: - Lifecycle
    
    init() {
        (reload, reloadObserver) = Signal.pipe()
        (showError, showErrorObserver) = Signal.pipe()
    }
}

// MARK: - DataSource

extension MainViewModel {
    var numberOfRows: Int {
        return characters.count
    }
    
    func character(at index: Int) -> CharacterMD? {
        guard 0..<characters.count ~= index else {
            return nil
        }
        
        return characters[index]
    }
}

// MARK: - Public

extension MainViewModel {
    func getCharacters() {
        getCharacters(page)
    }
    
    func willDisplay(_ index: Int) {
        let loadCountNumber = characters.count - 10
        
        if loadCountNumber == index, !finalPage {
            page += 1
            getCharacters(page)
        }
    }
}

// MARK: - Private

private extension MainViewModel {
    func getCharacters(_ page: Int) {
        _loading.value = page == 1
        
        CharacterManager.characters(page: page) { [weak self] characters, errorMessage in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf._loading.value = false
            
            if let errorActual = errorMessage {
                strongSelf.showErrorObserver.send(value: errorActual)
            } else if let charactersActual = characters {
                strongSelf.finalPage = charactersActual.count < strongSelf.countOnPage || charactersActual.count == 0
                
                for item in charactersActual {
                    strongSelf.characters.append(item)
                }
                
                strongSelf.reloadObserver.send(value: ())
            }
        }
    }
}
