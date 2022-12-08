//
//  DetailVC.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import ReactiveCocoa
import ReactiveSwift
import SVProgressHUD

class DetailVC: UIViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    
    private let viewModel: DetailViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showError: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showError(message)
        })
    }
    
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
        
        bindingViewModel()
        configure()
        
        viewModel.getFirstEpisode()
    }
}

// MARK: - Configure

private extension DetailVC {
    func configure() {
        title = viewModel.title
        tableView.register(EpisodeCell.self)
    }
}

// MARK: - BindingViewModel

private extension DetailVC {
    func bindingViewModel() {
        tableView.reactive.reloadData <~ viewModel.reload
        loaderView.reactive.isAnimating <~ viewModel.loading
        showError <~ viewModel.showError
    }
}

// MARK: - UITableViewDataSource

extension DetailVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows(at: section)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let sectionCellModel = viewModel.sectionCellModel(at: section)
        return sectionCellModel?.season
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: EpisodeCell = tableView.dequeueReusableCell(for: indexPath)
        let cellModel = viewModel.cellModel(at: indexPath.section, row: indexPath.row)
        cell.configure(cellModel)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension DetailVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Private

private extension DetailVC {
    func showError(_ error: String) {
        SVProgressHUD.show(withStatus: error)
        SVProgressHUD.dismiss(withDelay: 2)
    }
}
