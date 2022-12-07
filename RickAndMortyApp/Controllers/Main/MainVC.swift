//
//  MainVC.swift
//  RickAndMortyApp
//
//  Created by andrey rulev on 07.12.2022.
//

import ReactiveCocoa
import ReactiveSwift
import SVProgressHUD

class MainVC: UIViewController {
    
    // MARK: - Private properties
    
    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var loaderView: UIActivityIndicatorView!
    
    private let viewModel: MainViewModel
    private let (lifetime, token) = Lifetime.make()
    
    private var showError: BindingTarget<String> {
        return BindingTarget(lifetime: lifetime, action: { [weak self] message in
            self?.showError(message)
        })
    }
    
    // MARK: - Lifecycle
    
    init(viewModel: MainViewModel) {
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
        viewModel.getCharacters()
    }
}

// MARK: - Configure

private extension MainVC {
    func configure() {
        tableView.register(CharacterCell.self)
    }
}

// MARK: - BindingViewModel

private extension MainVC {
    func bindingViewModel() {
        tableView.reactive.reloadData <~ viewModel.reload
        loaderView.reactive.isAnimating <~ viewModel.loading
        showError <~ viewModel.showError
    }
}


// MARK: - UITableViewDataSource

extension MainVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CharacterCell = tableView.dequeueReusableCell(for: indexPath)
        let character = viewModel.character(at: indexPath.row)
        cell.configure(character)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height / 4
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewModel.willDisplay(indexPath.row)
    }
}

// MARK: - Private

private extension MainVC {
    func showError(_ error: String) {
        SVProgressHUD.show(withStatus: error)
        SVProgressHUD.dismiss(withDelay: 2)
    }
}

