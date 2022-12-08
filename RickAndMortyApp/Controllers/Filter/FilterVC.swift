//
//  FilterVC.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import UIKit

class FilterVC: UIViewController {
    
    // MARK: - Public properties
    
    var acceptedFilterType: ((FilterType?) -> Void)?
    
    // MARK: - Private properties
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var acceptButton: UIButton!
    
    private let viewModel: FilterViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
}

// MARK: - Configure

private extension FilterVC {
    func configure() {
        title = "Filter"
        
        tableView.register(FilterCell.self)
    }
}

// MARK: - Actions

private extension FilterVC {
    @IBAction func cancelButtonPressed() {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func acceptButtonPressed() {
        let filterType = viewModel.selectedFilterType()
        acceptedFilterType?(filterType)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - UITableViewDataSource

extension FilterVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FilterCell = tableView.dequeueReusableCell(for: indexPath)
        let cellModel = viewModel.cellModel(at: indexPath.row)
        cell.configure(cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension FilterVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectRow(at: indexPath.row)
        tableView.reloadData()
    }
}
