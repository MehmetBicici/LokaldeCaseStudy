//
//  FiltersViewController.swift
//  LokaldeCaseStudy
//
//  Created by Mehmet Biçici on 2.06.2026.
//

import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func didApplyFilters(_ selectedOptions: [FilterOptionModel], type: FilterType)
}

private enum Constants {
    static let backgroundColor: UIColor = .white
    
    enum TitleLabel {
        static let text: String = String(localized: "filter_title", defaultValue: "Select %@")
        static let titleColor: UIColor = .title
        static let titleFont: UIFont = .title
        static let textAlignment: NSTextAlignment = .center
    }
    
    enum CloseButton {
        static let image: UIImage = .crossIcon
        static let backgroundColor: UIColor = .systemGray6
        static let cornerRadius: CGFloat = 16.0
    }
    
    enum FilterTableView {
        static let cellIdentifier: String = "FiltersTableViewCell"
        static let cellHeight: CGFloat = 60.0
    }
    
    enum ApplyButton {
        static let title: String = String(localized: "apply_button_title", defaultValue: "Apply")
        static let backgroundColor: UIColor = .primary
        static let titleColor: UIColor = .white
    }
}

final class FiltersViewController: BaseViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var closeButton: UIButton!
    @IBOutlet private weak var filterTableView: UITableView!
    @IBOutlet private weak var applyButton: AppButton!
    
    private weak var delegate: FiltersViewControllerDelegate?
    private var viewModel: FiltersViewModelInterface
    
    init(viewModel: FiltersViewModelInterface, delegate: FiltersViewControllerDelegate? = nil) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: String(describing: FiltersViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. Use init(viewModel:delegate:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.setDelegate(self)
        viewModel.viewDidLoad()
    }
}

// MARK: - Actions
@objc
private extension FiltersViewController {
    func applyButtonTapped() {
        viewModel.applyFilters()
    }
    
    func closeButtonTapped() {
        dismiss(animated: true)
    }
}

private extension FiltersViewController {
    func setupUI() {
        view.backgroundColor = Constants.backgroundColor
        prepareTitleLabel()
        prepareCloseButton()
        prepareApplyButton()
        prepareTableView()
    }
    
    func prepareTitleLabel() {
        titleLabel.font = Constants.TitleLabel.titleFont
        titleLabel.textColor = Constants.TitleLabel.titleColor
        titleLabel.text = String(format: Constants.TitleLabel.text, viewModel.pageTitle)
        titleLabel.textAlignment = Constants.TitleLabel.textAlignment
    }
    
    func prepareCloseButton() {
        closeButton.setImage(Constants.CloseButton.image, for: .normal)
        closeButton.backgroundColor = Constants.CloseButton.backgroundColor
        closeButton.layer.cornerRadius = Constants.CloseButton.cornerRadius
        closeButton.tintColor = .black
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func prepareApplyButton() {
        applyButton.configure(
            title: Constants.ApplyButton.title,
            bgColor: Constants.ApplyButton.backgroundColor,
            titleColor: Constants.ApplyButton.titleColor
        )
        applyButton.addTarget(self, action: #selector(applyButtonTapped), for: .touchUpInside)
    }
    
    func prepareTableView() {
        filterTableView.delegate = self
        filterTableView.dataSource = self
        filterTableView.separatorStyle = .none
        filterTableView.backgroundColor = .clear
        filterTableView.showsVerticalScrollIndicator = false
        
        let nib = UINib(nibName: Constants.FilterTableView.cellIdentifier, bundle: nil)
        filterTableView.register(nib, forCellReuseIdentifier: Constants.FilterTableView.cellIdentifier)
    }
}

// MARK: - UITableViewDataSource & Delegate
extension FiltersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.FilterTableView.cellIdentifier, for: indexPath) as? FiltersTableViewCell else {
            return UITableViewCell()
        }
        
        let model = viewModel.options[indexPath.row]
        cell.configure(with: model)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.FilterTableView.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleSelection(at: indexPath.row)
    }
}

// MARK: - FiltersViewModelDelegate
extension FiltersViewController: FiltersViewModelDelegate {
    func reloadFilters() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.filterTableView.reloadData()
        }
    }
    
    func dismissAndApplyFilters(selectedOptions: [FilterOptionModel], filterType: FilterType) {
        delegate?.didApplyFilters(selectedOptions, type: filterType)
        dismiss(animated: true)
    }
}
