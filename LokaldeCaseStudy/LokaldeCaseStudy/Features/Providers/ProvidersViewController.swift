//
//  ProvidersViewController.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

private enum Constants {
    static let backgroundColor: UIColor = .background
    static let title: String = String(localized: "providers_title", defaultValue: "Healthcare Providers")
    static let titleColor: UIColor = .title
    
    enum SearchController {
        static let placeholder: String = String(localized: "search_placeholder_text", defaultValue: "Look for a doctor, clinic, or hospital...")
        static let backgroundColor: UIColor = .white
        static let textColor: UIColor = .secondary.withAlphaComponent(0.6)
        static let iconColor: UIColor = .secondary.withAlphaComponent(0.6)
        static let cornerRadius: CGFloat = 18
        static let borderColor: UIColor = .stroke.withAlphaComponent(0.5)
        static let borderWidth: CGFloat = 1.0
    }
    
    enum FilterPillCollectionView {
        static let cellIdentifier: String = "FilterPillCollectionViewCell"
        static let cellHeight: CGFloat = 36.0
        static let horizontalPadding: CGFloat = 32.0
        static let interitemSpacing: CGFloat = 8.0
        static let sectionInset: CGFloat = 8.0
        static let fontSize: CGFloat = 15.0
    }
    
    enum ProvidersListTableView {
        static let cellIdentifier: String = "ProviderListTableViewCell"
        static let cellHeight: CGFloat = 116.0
        static let numberOfRowsInSection: Int = 1
    }
    
    enum Animation {
        static let duration: CGFloat = 0.3
    }
    
    enum InfoStateView {
        static let padding: CGFloat = 16
    }
}

final class ProvidersViewController: BaseViewController {
    
    @IBOutlet private weak var filterPillCollectionView: UICollectionView!
    @IBOutlet private weak var providersListTableView: UITableView!
    
    private lazy var viewModel: ProvidersViewModelInterface = {
        return ProvidersViewModel(delegate: self)
    }()
    
    private lazy var infoStateView: InfoStateView = {
        let view = InfoStateView(delegate: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.loadFilters()
        viewModel.loadProviders()
    }
}

private extension ProvidersViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        setupNavigationTitle()
        setupSearchController()
        setupCollectionView()
        setupTableView()
        setupInfoStateView()
    }
    
    func setupInfoStateView() {
        view.addSubview(infoStateView)
        
        NSLayoutConstraint.activate([
            infoStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            infoStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.InfoStateView.padding),
            infoStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.InfoStateView.padding)
        ])
    }
    
    func setupNavigationTitle() {
        title = Constants.title
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: Constants.titleColor
        ]
    }
    
    func setupSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        
        let searchBar = searchController.searchBar
        let searchTextField = searchBar.searchTextField
        
        searchBar.searchBarStyle = .minimal
        searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default)
        searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        
        searchTextField.backgroundColor = Constants.SearchController.backgroundColor
        
        searchTextField.layer.cornerRadius = Constants.SearchController.cornerRadius
        searchTextField.layer.masksToBounds = true
        searchTextField.layer.borderWidth = Constants.SearchController.borderWidth
        searchTextField.layer.borderColor = Constants.SearchController.borderColor.cgColor
        
        searchTextField.textColor = Constants.SearchController.textColor
        searchTextField.tintColor = Constants.SearchController.textColor
        
        searchTextField.typingAttributes = [
            .foregroundColor: Constants.SearchController.textColor
        ]
        
        searchTextField.defaultTextAttributes = [
            .foregroundColor: Constants.SearchController.textColor
        ]
        
        searchTextField.attributedPlaceholder = NSAttributedString(
            string: Constants.SearchController.placeholder,
            attributes: [
                .foregroundColor: Constants.SearchController.textColor
            ]
        )
        
        if let leftIconView = searchTextField.leftView as? UIImageView {
            leftIconView.image = leftIconView.image?.withRenderingMode(.alwaysTemplate)
            leftIconView.tintColor = Constants.SearchController.iconColor
        }
        
        if let clearButton = searchTextField.value(forKey: "_clearButton") as? UIButton {
            clearButton.tintColor = Constants.SearchController.iconColor
            clearButton.setImage(
                clearButton.image(for: .normal)?.withRenderingMode(.alwaysTemplate),
                for: .normal
            )
        }
        
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        DispatchQueue.main.async {
            searchTextField.textColor = Constants.SearchController.textColor
        }
    }
    
    func setupCollectionView() {
        if let layout = filterPillCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumInteritemSpacing = Constants.FilterPillCollectionView.interitemSpacing
            let inset = Constants.FilterPillCollectionView.sectionInset
            layout.sectionInset = UIEdgeInsets(top: .zero, left: inset, bottom: .zero, right: inset)
        }
        filterPillCollectionView.showsHorizontalScrollIndicator = false
        filterPillCollectionView.allowsMultipleSelection = true
        
        filterPillCollectionView.delegate = self
        filterPillCollectionView.dataSource = self
        
        let nib = UINib(nibName: Constants.FilterPillCollectionView.cellIdentifier, bundle: nil)
        filterPillCollectionView.register(nib, forCellWithReuseIdentifier: Constants.FilterPillCollectionView.cellIdentifier)
    }
    
    func setupTableView() {
        providersListTableView.delegate = self
        providersListTableView.dataSource = self
        providersListTableView.separatorStyle = .none
        providersListTableView.backgroundColor = .clear
        providersListTableView.showsVerticalScrollIndicator = false
        
        let nib = UINib(nibName: Constants.ProvidersListTableView.cellIdentifier, bundle: nil)
        providersListTableView.register(nib, forCellReuseIdentifier: Constants.ProvidersListTableView.cellIdentifier)
    }
}

extension ProvidersViewController: InfoStateViewDelegate {
    func didTapRetryButton() {
        infoStateView.isHidden = true
        viewModel.loadProviders()
    }
}

extension ProvidersViewController: ProvidersViewModelDelegate {
    
    func updateLoadingState(show: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            
            guard !show else {
                self.showLoading()
                self.filterPillCollectionView.isHidden = true
                self.providersListTableView.isHidden = true
                return
            }
            
            self.hideLoading()
            
            UIView.transition(
                with: self.providersListTableView,
                duration: Constants.Animation.duration,
                options: .transitionCrossDissolve,
                animations: {
                    self.filterPillCollectionView.isHidden = false
                    self.providersListTableView.isHidden = false
                }
            )
        }
    }
    
    func reloadFilters() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.filterPillCollectionView.reloadData()
        }
    }
    
    func reloadProviders() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.infoStateView.isHidden = true
            self.providersListTableView.isHidden = false
            self.filterPillCollectionView.isHidden = false
            self.providersListTableView.reloadData()
        }
    }
    
    func showEmptyState() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.filterPillCollectionView.isHidden = true
            self.providersListTableView.isHidden = true
            self.infoStateView.configure(with: .emptySearch)
            self.infoStateView.isHidden = false
        }
    }
    
    func showErrorState(message: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.filterPillCollectionView.isHidden = true
            self.providersListTableView.isHidden = true
            self.infoStateView.configure(with: .error(message: message))
            self.infoStateView.isHidden = false
        }
    }
}

extension ProvidersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let query = searchController.searchBar.text ?? ""
        viewModel.updateSearchQuery(query)
    }
}

extension ProvidersViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.filters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: Constants.FilterPillCollectionView.cellIdentifier,
            for: indexPath
        ) as? FilterPillCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let model = viewModel.filters[indexPath.row]
        cell.configure(with: model)
        
        guard model.isSelected else {
            collectionView.deselectItem(at: indexPath, animated: false)
            return cell
        }
        
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: [])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.toggleFilterSelection(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        viewModel.toggleFilterSelection(at: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let filterTitle = viewModel.filters[indexPath.row].title
        let font = UIFont.systemFont(ofSize: Constants.FilterPillCollectionView.fontSize, weight: .regular)
        
        let textWidth = filterTitle.size(withAttributes: [.font: font]).width
        let cellWidth = textWidth + Constants.FilterPillCollectionView.horizontalPadding
        
        return CGSize(width: cellWidth, height: Constants.FilterPillCollectionView.cellHeight)
    }
}

extension ProvidersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.providers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.ProvidersListTableView.numberOfRowsInSection
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.ProvidersListTableView.cellIdentifier, for: indexPath) as? ProviderListTableViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.providers[indexPath.section]
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.ProvidersListTableView.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // İleride detay sayfasına gitmek için burası kullanılacak
        let selectedProvider = viewModel.providers[indexPath.section]
        print("\(selectedProvider.name) seçildi.")
    }
}
