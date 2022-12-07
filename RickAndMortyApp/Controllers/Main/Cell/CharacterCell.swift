//
//  CharacterCell.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit
import SDWebImage

class CharacterCell: BaseTableViewCell {
    
    // MARK: - Private properties
    
    @IBOutlet private var avatarImage: UIImageView!
    @IBOutlet private var nameLablel: UILabel!
    @IBOutlet private var planetLablel: UILabel!
    @IBOutlet private var stateLablel: UILabel!
    
    // MARK: - AwakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        avatarImage.layer.cornerRadius = avatarImage.frame.width / 2
    }
    
    // MARK: - PrepareForReuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        avatarImage.sd_cancelCurrentImageLoad()
        avatarImage.layer.removeAllAnimations()
        avatarImage.image = nil
        nameLablel.text = nil
        planetLablel.text = nil
        stateLablel.text = nil
    }
    
    // MARK: - Configure
    
    func configure(_ character: CharacterMD?) {
        if let avatarLink = character?.image,
           let avatarUrl = URL(string: avatarLink) {
            avatarImage.sd_setImage(with: avatarUrl)
        }
        
        nameLablel.text = character?.name
        planetLablel.text = character?.location.name
        stateLablel.text = character?.status
    }
}
