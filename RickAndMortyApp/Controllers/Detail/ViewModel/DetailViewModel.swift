//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import ReactiveCocoa
import ReactiveSwift

struct EpisodeCellModel {
    let name: String
    let date: String
    let season: String
}

class DetailViewModel {
    
    // MARK: - Public properties
    
    var title: String {
        return character.name
    }
    
    let reload: Signal<(), Never>
    let showError: Signal<String, Never>
    var loading: Property<Bool> { return Property(_loading) }
    
    // MARK: - Private properties
    
    private let reloadObserver: Signal<(), Never>.Observer
    private let showErrorObserver: Signal<String, Never>.Observer
    private let _loading: MutableProperty<Bool> = MutableProperty(false)
    
    private let character: CharacterMD
    private var cellModels = [EpisodeCellModel]()
    private var currentEpisode = 0
    private let dateFormatter = DateFormatter()
    
    // MARK: - Lifecycle
    
    init(character: CharacterMD) {
        self.character = character
        (reload, reloadObserver) = Signal.pipe()
        (showError, showErrorObserver) = Signal.pipe()
    }
}

// MARK: - DataSource

extension DetailViewModel {
    var numberOfRows: Int {
        return cellModels.count
    }
    
    func cellModel(at index: Int) -> EpisodeCellModel? {
        guard 0..<cellModels.count ~= index else {
            return nil
        }
        
        return cellModels[index]
    }
}

// MARK: - Public

extension DetailViewModel {
    func getFirstEpisode() {
        let firstEpisode = character.episode[currentEpisode]
        
        _loading.value = true
        getEpisode(firstEpisode)
    }
}

// MARK: - Private

private extension DetailViewModel {
    func getNextEpisode() {
        guard 0..<character.episode.count ~= currentEpisode else {
            return
        }
        
        let nextEpisode = character.episode[currentEpisode]
        getEpisode(nextEpisode)
    }
    
    func getEpisode(_ episode: String) {
        EpisodeManager.episode(episode) { [weak self] episode, errorMessage in
            guard let strongSelf = self else {
                return
            }
            
            if let errorActual = errorMessage {
                strongSelf._loading.value = false
                strongSelf.showErrorObserver.send(value: errorActual)
            } else if let episodeActual = episode {
                strongSelf.dateFormatter.dateFormat = "MMMM d, yyyy"
                
                let dateString: String
                
                if let date = strongSelf.dateFormatter.date(from: episodeActual.airDate) {
                    strongSelf.dateFormatter.dateFormat = "d MMMM yyyy"
                    dateString = strongSelf.dateFormatter.string(from: date)
                } else {
                    dateString = ""
                }
                
                let cellModel = EpisodeCellModel(name: episodeActual.name,
                                                 date: dateString,
                                                 season: episodeActual.episode)
                
                strongSelf.cellModels.append(cellModel)
                strongSelf.reloadObserver.send(value: ())
                
                if strongSelf.character.episode.count - 1 != strongSelf.currentEpisode {
                    strongSelf.currentEpisode += 1
                    strongSelf.getNextEpisode()
                } else {
                    strongSelf._loading.value = false
                }
            }
        }
    }
}
