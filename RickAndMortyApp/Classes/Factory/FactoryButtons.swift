//
//  FactoryButtons.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit

class FactoryButtons {
    class func createButton(title: String,
                            target: Any,
                            selector: Selector) -> UIBarButtonItem {
        let button = UIBarButtonItem(title: title,
                                     style: .plain,
                                     target: target,
                                     action: selector)
        return button
    }
}
