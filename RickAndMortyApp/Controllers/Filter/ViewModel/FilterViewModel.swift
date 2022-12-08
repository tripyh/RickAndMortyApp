//
//  FilterViewModel.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import Foundation

enum FilterType: String, CaseIterable {
    case alive
    case dead
    case unknown
}

struct FilterCellModel {
    let filterType: FilterType
    var isSelected: Bool
    
    var title: String {
        switch filterType {
        case .alive:
            return "Alive"
        case .dead:
            return "Dead"
        case .unknown:
            return "Unknown"
        }
    }
}

class FilterViewModel {
    
    // MARK: - Private properties
    
    private var cellModels = [FilterCellModel]()
    private let filterType: FilterType?
    
    // MARK: - Lifecycle
    
    init(filterType: FilterType?) {
        self.filterType = filterType
        fillCellModels()
    }
}

// MARK: - DataSource

extension FilterViewModel {
    var numberOfRows: Int {
        return cellModels.count
    }
    
    func cellModel(at index: Int) -> FilterCellModel? {
        guard 0..<cellModels.count ~= index else {
            return nil
        }
        
        return cellModels[index]
    }
    
    func didSelectRow(at index: Int) {
        guard var cellModel = cellModel(at: index) else {
            return
        }
        
        cellModel.isSelected = !cellModel.isSelected
        
        cellModels[index] = cellModel
    }
    
    func selectedFilterType() -> FilterType? {
        let cellModel = cellModels.filter({$0.isSelected == true }).first
        return cellModel?.filterType
    }
}

// MARK: - Private

private extension FilterViewModel {
    func fillCellModels() {
        for item in FilterType.allCases {
            var isSelected = false
            
            if let filterTypeActual = filterType {
                isSelected = filterTypeActual == item
            }
            
            let cellModel = FilterCellModel(filterType: item, isSelected: isSelected)
            cellModels.append(cellModel)
        }
    }
}
