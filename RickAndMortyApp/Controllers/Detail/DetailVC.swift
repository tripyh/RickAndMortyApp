//
//  DetailVC.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit

class DetailVC: UIViewController {
    
    // MARK: - Private properties
    
    private let viewModel: DetailViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
