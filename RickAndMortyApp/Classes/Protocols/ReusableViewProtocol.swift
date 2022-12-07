//
//  ReusableViewProtocol.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit

protocol ReusableViewProtocol: AnyObject {
    static var reuseIdentifier: String { get }
}

extension ReusableViewProtocol where Self: UITableViewCell {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}
