//
//  ItemListViewController.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

// MARK: - INavigationItemListViewController Protocol
protocol INavigationItemListViewController: AnyObject
{
	var navigationController: UINavigationController? { get }
}

// MARK: - IItemListViewController Protocol
protocol IItemListViewController: AnyObject
{
	func showItems()
	func showStub(with message: String)
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
		controller.searchBar.searchBarStyle = .minimal
		controller.searchBar.returnKeyType = .done
		return controller
	}()

	private let stubView = StubView()

	private var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		if #available(iOS 13.0, *) {
			indicator.style = .large
			indicator.color = .label
		}
		else {
			indicator.style = .whiteLarge
			indicator.color = .black
		}
		return indicator
	}()

	private var isSearchBarEmpty: Bool {
		resultSearchController.searchBar.text?.isEmpty ?? true
	}

	private var indexPathForSelectedRow: IndexPath?
	private static var cellIdentifier = "ItemCell"

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
		setup()
		setConstraints()
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
	private func setup() {

		view.addSubview(tableView)
		view.addSubview(stubView)
		view.addSubview(activityIndicator)

		tableView.register(DetailItemTableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)

		// Search bar
		navigationItem.searchController = resultSearchController
		definesPresentationContext = true
		navigationItem.hidesSearchBarWhenScrolling = false
	}

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

		// Stub view constraints
		stubView.translatesAutoresizingMaskIntoConstraints = false
		stubView.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
		stubView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
		stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

		// Activity indicator constraints
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}
}

// MARK: - INavigationItemListViewController
extension ItemListViewController: INavigationItemListViewController { }

// MARK: - ICharacterListViewController
extension ItemListViewController: IItemListViewController
{
	func showItems() {
		activityIndicator.stopAnimating()
		tableView.reloadData()
		tableView.alpha = 1
		tableView.isHidden = false
		stubView.isHidden = true
	}

	func showStub(with message: String) {
		activityIndicator.stopAnimating()
		tableView.isHidden = true
		stubView.setTitle(message)
		stubView.isHidden = false
	}
}

// MARK: - Search bar delegate
extension ItemListViewController: UISearchBarDelegate
{
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		activityIndicator.startAnimating()
		tableView.alpha = 0.5
		stubView.isHidden = true
		presenter.performLoadItems(after: 0.7, with: searchBar.text ?? "")
	}
}

// MARK: - Table view data source
extension ItemListViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.tableViewViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier,
												 for: indexPath) as? DetailItemTableViewCell

		let viewModel = presenter.tableViewViewModels[indexPath.row]
		cell?.updateIcon(image: nil)
		cell?.configure(using: viewModel)
		presenter.onThumbnailUpdate(by: viewModel.thumbnail,
									aspectRatio: .portrait(.small)) { image in
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
