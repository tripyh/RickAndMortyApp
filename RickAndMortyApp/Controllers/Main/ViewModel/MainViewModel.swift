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
    
    var filterType: FilterType? {
        return currentFilter
    }
    
    // MARK: - Private properties
    
    private let reloadObserver: Signal<(), Never>.Observer
    private let showErrorObserver: Signal<String, Never>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    
    private var characters = [CharacterMD]()
    private let countOnPage = 20
    private var finalPage = false
    private var page = 1
    private var currentFilter: FilterType?
    
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
        getCharacters(page, filterType: currentFilter)
    }
    
    func willDisplay(_ index: Int) {
        let loadCountNumber = characters.count - 10
        
        if loadCountNumber == index, !finalPage {
            page += 1
            getCharacters(page, filterType: currentFilter)
        }
    }
    
    func updateFilterType(_ filterType: FilterType?) {
        currentFilter = filterType
        characters = [CharacterMD]()
        page = 0
        finalPage = false
        reloadObserver.send(value: ())        
        getCharacters(page, filterType: currentFilter)
    }
}

// MARK: - Private

private extension MainViewModel {
    func getCharacters(_ page: Int, filterType: FilterType?) {
        _loading.value = page == 1
        
        var params = [String: Any]()
        params["page"] = page
        
        if let filterTypeActual = filterType {
            params["status"] = filterTypeActual.rawValue
        }
        
        CharacterManager.characters(params: params) { [weak self] characters, errorMessage in
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
