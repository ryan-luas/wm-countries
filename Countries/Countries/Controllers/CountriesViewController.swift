//
//  ViewController.swift
//  Countries
//
//  Created by Ryan Luas on 7/1/25.
//

import UIKit

class CountriesViewController: UIViewController {
    let cellIdentifier = Constants.countryCellIdentifier
    var searchController: UISearchController!
    var viewModel = CountriesControllerViewModel()

    // MARK: - UI Elements
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()

    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .systemBlue
        return indicator
    }()

    let emptyStateView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    private let emptyStateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.attributedTitle = NSAttributedString(string: Constants.pullToRefreshLabel)
        return control
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupUI()
        setupSearchController()
        setupRefreshControl()
        setupNotifications()
        viewModel.loadCountries()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: animated)
        }
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

        coordinator.animate(alongsideTransition: { _ in
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        })
    }

    deinit {
        viewModel.cancelDataTask()
        NotificationCenter.default.removeObserver(self)
    }

    // MARK: - ViewModel Setup
    private func setupViewModel() {
        viewModel.delegate = self
    }

    // MARK: - UI Setup
    private func setupUI() {
        title = Constants.rootNavTitleLabel
        view.backgroundColor = .systemBackground

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

        let retryButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(retryButtonTapped)
        )
        navigationItem.rightBarButtonItem = retryButton

        // Setup empty state
        emptyStateView.addSubview(emptyStateLabel)

        // Add subviews
        view.addSubview(tableView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyStateView)

        // Setup constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            emptyStateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            emptyStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emptyStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            emptyStateLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor),
            emptyStateLabel.centerYAnchor.constraint(equalTo: emptyStateView.centerYAnchor),
            emptyStateLabel.leadingAnchor.constraint(equalTo: emptyStateView.leadingAnchor),
            emptyStateLabel.trailingAnchor.constraint(equalTo: emptyStateView.trailingAnchor)
        ])
    }

    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.searchBar.delegate = self

        // Configure search controller
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = Constants.preSearchDefaultPlaceholderLabel
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.enablesReturnKeyAutomatically = false

        // Add search controller to navigation
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        definesPresentationContext = true
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(contentSizeCategoryDidChange),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil
        )
    }

    @objc private func contentSizeCategoryDidChange() {
        // Reload table view to update cell heights for Dynamic Type
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

// MARK: - State Management
    func showLoadingState() {
        if viewModel.numberOfCountries == 0 {
            activityIndicator.startAnimating()
            emptyStateView.isHidden = true
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
    }

    func hideLoadingState() {
        activityIndicator.stopAnimating()
        refreshControl.endRefreshing()
        navigationItem.rightBarButtonItem?.isEnabled = true
    }

    func showSuccessState() {
        emptyStateView.isHidden = true
    }

    func showEmptyState(_ message: String) {
        emptyStateLabel.text = message
        emptyStateView.isHidden = false
    }

// MARK: - Error Handling
    func handleLoadingError(_ error: NetworkError) {
        let message: String
        let showRetry: Bool

        switch error {
        case .invalidURL:
            message = Constants.invalidUrlConfigError
            showRetry = false
        case .noData:
            message = Constants.noDataReceivedError
            showRetry = true
        case .emptyData:
            message = Constants.countryListEmptyError
            showRetry = true
        case .invalidResponse:
            message = Constants.invalidServerResponseError
            showRetry = true
        case .serverError(let code):
            message = Constants.serverError.appending(String(code)).appending(Constants.serverErrorAddlContext)
            showRetry = true
        case .requestFailed(let underlyingError):
            if (underlyingError as NSError).code == NSURLErrorNotConnectedToInternet {
                message = Constants.requestFailedCheckConnectionError
            } else if (underlyingError as NSError).code == NSURLErrorTimedOut {
                message = Constants.requestTimedOutError
            } else {
                message = Constants.networkError.appending(underlyingError.localizedDescription)
            }
            showRetry = true
        case .parsingFailed(let underlyingError):
            message = Constants.failedToParseError.appending(underlyingError.localizedDescription)
            showRetry = true
        }

        if viewModel.numberOfCountries == 0 {
            showEmptyState(message)
        } else {
            showErrorAlert(message: message, showRetry: showRetry)
        }
    }

    func showErrorAlert(message: String, showRetry: Bool) {
        let alert = UIAlertController(title: Constants.alertControllerTitle,
                                      message: message,
                                      preferredStyle: .alert)

        if showRetry {
            alert.addAction(UIAlertAction(title: Constants.retryActionTitle, style: .default) { _ in
                self.viewModel.loadCountries()
            })
        }

        alert.addAction(UIAlertAction(title: Constants.okActionLabel, style: .cancel))

        present(alert, animated: true)
    }

// MARK: - Actions
    @objc func retryButtonTapped() {
        viewModel.loadCountries()
    }

    @objc func refreshData() {
        viewModel.loadCountries()
    }

    var isSearching: Bool {
        return viewModel.isSearching
    }
}
