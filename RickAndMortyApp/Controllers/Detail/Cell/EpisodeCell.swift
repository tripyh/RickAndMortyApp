//
//  EpisodeCell.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit

class EpisodeCell: BaseTableViewCell {
    
    // MARK: - Private properties
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var seasondeLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    // MARK: - PrepareForReuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        seasondeLabel.text = nil
        dateLabel.text = nil
    }
    
    // MARK: - Configure
    
    func configure(_ cellModel: EpisodeCellModel?) {
        nameLabel.text = cellModel?.name
        seasondeLabel.text = cellModel?.season
        dateLabel.text = cellModel?.date
    }
}
