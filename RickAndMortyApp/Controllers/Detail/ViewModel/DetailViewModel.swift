//
//  DetailViewModel.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import ReactiveCocoa
import ReactiveSwift

struct EpisodeSectionCellModel {
    let season: String
    var cellModels: [EpisodeCellModel]
}

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
    private var sectionCellModels = [EpisodeSectionCellModel]()
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
    func numberOfRows(at section: Int) -> Int {
        guard 0..<sectionCellModels.count ~= section else {
            return 0
        }
        
        return sectionCellModels[section].cellModels.count
    }
    
    var numberOfSections: Int {
        return sectionCellModels.count
    }
    
    func sectionCellModel(at section: Int) -> EpisodeSectionCellModel? {
        guard 0..<sectionCellModels.count ~= section else {
            return nil
        }
        
        return sectionCellModels[section]
    }
    
    func cellModel(at section: Int, row: Int) -> EpisodeCellModel? {
        guard 0..<sectionCellModels.count ~= section else {
            return nil
        }
        
        guard 0..<sectionCellModels[section].cellModels.count ~= row else {
            return nil
        }
        
        return sectionCellModels[section].cellModels[row]
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
                strongSelf.addNewEpisode(episodeActual)
            }
        }
    }
    
    func addNewEpisode(_ episode: EpisodeMD) {
        let cellModel = createEpisodeCellModel(episode)
        
        if sectionCellModels.isEmpty {
            addSectionCellModel(cellModel)
        } else {
            //
            // it works until episode 99
            //
            
            let newSectionName = cellModel.season.prefix(3)
            var isExistSection = false
            
            for i in 0..<sectionCellModels.count {
                var sectionCell = sectionCellModels[i]
                let sectionName = sectionCell.season.prefix(3)
                
                if sectionName == newSectionName {
                    isExistSection = true
                    var cellModels = sectionCell.cellModels
                    cellModels.append(cellModel)
                    sectionCell.cellModels = cellModels
                    sectionCellModels[i] = sectionCell
                }
            }
            
            if !isExistSection {
                addSectionCellModel(cellModel)
            }
        }
        
        reloadObserver.send(value: ())
        
        if character.episode.count - 1 != currentEpisode {
            currentEpisode += 1
            getNextEpisode()
        } else {
            _loading.value = false
        }
    }
    
    func addSectionCellModel(_ cellModel: EpisodeCellModel) {
        let sectionCellModel = EpisodeSectionCellModel(season: cellModel.season,
                                                       cellModels: [cellModel])
        sectionCellModels.append(sectionCellModel)
    }
    
    func createEpisodeCellModel(_ episode: EpisodeMD) -> EpisodeCellModel {
        dateFormatter.dateFormat = "MMMM d, yyyy"
        
        let dateString: String
        
        if let date = dateFormatter.date(from: episode.airDate) {
            dateFormatter.dateFormat = "d MMMM yyyy"
            dateString = dateFormatter.string(from: date)
        } else {
            dateString = ""
        }
        
        let cellModel = EpisodeCellModel(name: episode.name,
                                         date: dateString,
                                         season: episode.episode)
        return cellModel
    }
}
