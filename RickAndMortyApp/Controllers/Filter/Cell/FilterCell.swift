//
//  FilterCell.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit

class FilterCell: BaseTableViewCell {
    
    // MARK: - Private properties
    
    @IBOutlet private var nameLabel: UILabel!
    
    // MARK: - prepareForReuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        nameLabel.textColor = .black
    }
    
    // MARK: - Configure
    
    func configure(_ cellModel: FilterCellModel?) {
        nameLabel.text = cellModel?.title
        
        if let isSelected = cellModel?.isSelected, isSelected {
            nameLabel.textColor = .blue
        } else {
            nameLabel.textColor = .black
        }
    }
}
