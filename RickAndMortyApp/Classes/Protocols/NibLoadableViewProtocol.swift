//
//  NibLoadableViewProtocol.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit

protocol NibLoadableViewProtocol: AnyObject {
    static var nibName: String { get }
}

extension NibLoadableViewProtocol where Self: UITableViewCell {
    static var nibName: String {
        return String(describing: self)
    }
}
