//
//  ItemListViewController.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

// MARK: - IItemListViewController Protocol
protocol IItemListViewController: AnyObject
{
	var navController: UINavigationController? { get }

	func showItems()
	func showAlert(with message: String)
}

// MARK: - Class
final class ItemListViewController: UIViewController
{

	// MARK: ...Private properties
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.isHidden = true
		tableView.keyboardDismissMode = .onDrag
		return tableView
	}()

	private lazy var resultSearchController: UISearchController = {
		let controller = UISearchController(searchResultsController: nil)
		controller.searchBar.delegate = self
		controller.obscuresBackgroundDuringPresentation = false
		controller.searchBar.placeholder = "Start typing \(presenter.itemType.rawValue.lowercased())..."
		self.navigationItem.searchController = controller
		self.definesPresentationContext = true
		return controller
	}()

	private var alertView: AlertView = {
		let alertView = AlertView()
		return alertView
	}()

	private var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		if #available(iOS 13.0, *) {
			indicator.color = .label
			indicator.style = .large
		}
		else {
			indicator.color = .black
			indicator.style = .whiteLarge
		}
		return indicator
	}()

	private var isSearchBarEmpty: Bool {
		resultSearchController.searchBar.text?.isEmpty ?? true
	}

	private var indexPathForSelectedRow: IndexPath?

	private let presenter: IItemListPresenter

	// MARK: ...Initialization
	init(presenter: IItemListPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: ...Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		view.addSubview(tableView)
		view.addSubview(alertView)
		view.addSubview(activityIndicator)

		_ = resultSearchController.searchBar
		setConstraints()

		tableView.register(DetailItemTableViewCell.self, forCellReuseIdentifier: "Cell")
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.largeTitleDisplayMode = .automatic
		if let indexPath = indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		navigationItem.largeTitleDisplayMode = .never
	}

	// MARK: ...Private methods
	private func setConstraints() {
		var selfView: UILayoutGuide
		if #available(iOS 11.0, *) {
			selfView = self.view.safeAreaLayoutGuide
		}
		else {
			selfView = self.view.layoutMarginsGuide
		}

		// Table view constraints
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: selfView.topAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: selfView.bottomAnchor).isActive = true

		// Alert view constraints
		alertView.translatesAutoresizingMaskIntoConstraints = false
		alertView.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
		alertView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
		alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

		// Activity indicator constraints
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
}

// MARK: - ICharacterListViewController
extension ItemListViewController: IItemListViewController
{
	var navController: UINavigationController? { navigationController }

	func showItems() {
		tableView.reloadData()
		tableView.alpha = 1
		activityIndicator.stopAnimating()
		tableView.isHidden = false
		alertView.isHidden = true
		print("---")
	}

	func showAlert(with message: String) {
		activityIndicator.stopAnimating()
		tableView.isHidden = true
		alertView.setTitle(message)
		alertView.isHidden = false
		print("ERROR")
	}
}

// MARK: - Search bar delegate
extension ItemListViewController: UISearchBarDelegate
{
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		activityIndicator.startAnimating()
		tableView.alpha = 0.5
		alertView.isHidden = true
		filterContentForSearchText(searchBar.text ?? "")
	}

	private func filterContentForSearchText(_ searchText: String) {
		presenter.performLoadItems(after: 0.7,
								   with: searchText)
	}
}

// MARK: - Table view data source
extension ItemListViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.tableViewViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? DetailItemTableViewCell

		let viewModel = presenter.tableViewViewModels[indexPath.row]

		cell?.configure(using: viewModel)
		cell?.updateIcon(image: #imageLiteral(resourceName: "placeholder"))
		presenter.onThumbnailUpdate(
			by: viewModel.thumbnail.path,
			extension: viewModel.thumbnail.extension.rawValue) { image in
				cell?.updateIcon(image: image)
		}
		return cell ?? UITableViewCell()
	}
}

// MARK: - Table view delegate
extension ItemListViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.showDetail(viewModel: presenter.tableViewViewModels[indexPath.row])
		indexPathForSelectedRow = indexPath
	}
}
