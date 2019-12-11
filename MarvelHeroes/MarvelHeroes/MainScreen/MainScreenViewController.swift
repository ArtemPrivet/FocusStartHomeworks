//
//  TestMainScreenViewController.swift
//  MarvelHeroes
//
//  Created by Антон on 07.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import UIKit
protocol IMainScreenPresenter
{
	func getTitle() -> String
	func getRowsCount() -> Int
	func getTextLabelForCell(at indexPath: IndexPath) -> String
	func getDetailTextLabelForCell(at indexPath: IndexPath) -> String
	func getData(text: String)
	func getImageDataForCell(at indexPath: IndexPath, callBack: @escaping (Data) -> Void)
	func getPlaceholderFromSearchBar() -> String
	func attachViewController(viewController: MainScreenViewController)
	func showDetail(at indexPath: IndexPath)
}

final class MainScreenViewController: UIViewController
{
	private let presenter: MainScreenPresenter
	private let tableView = UITableView()
	private let searchController = UISearchController(searchResultsController: nil)
	private let notFoundImageView = NotFoundImageView()
	private let containerView = UIView()
	private let loadingView = UIView()
	private let activityIndicator = UIActivityIndicatorView()

	private func setupTableView() {
		var heightTabBar: CGFloat = 0
		self.view.addSubview(tableView)
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.tableFooterView = UIView()
		if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
			heightTabBar = tabBarHeight
		}
		NSLayoutConstraint.activate([
			self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -heightTabBar),
			self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
		])
		self.tableView.rowHeight = UITableView.automaticDimension
	}

	private func setupSearchBar() {
		if #available(iOS 11.0, *) {
			searchController.searchBar.placeholder = presenter.getPlaceholderFromSearchBar()
			self.navigationItem.searchController = searchController
			self.navigationItem.hidesSearchBarWhenScrolling = false
			self.navigationItem.searchController?.obscuresBackgroundDuringPresentation = false
			self.navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
		}
		else {
			searchController.searchBar.searchBarStyle = .prominent
			self.tableView.tableHeaderView = searchController.searchBar
		}
	}

	init(presenter: MainScreenPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available (*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		searchController.searchBar.delegate = self
		self.navigationItem.title = presenter.getTitle()
		self.navigationController?.navigationBar.isTranslucent = false
		if #available(iOS 11.0, *) {
			self.navigationController?.navigationBar.prefersLargeTitles = true
		}
		self.navigationController?.view.backgroundColor = .white
		setupTableView()
		setupSearchBar()
		presenter.attachViewController(viewController: self)
	}
}
// MARK: UITableViewDataSource
extension MainScreenViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getRowsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = presenter.getTextLabelForCell(at: indexPath)
		cell.detailTextLabel?.text = presenter.getDetailTextLabelForCell(at: indexPath)
		cell.detailTextLabel?.textColor = #colorLiteral(red: 0.5406504869, green: 0.5422019362, blue: 0.5556592345, alpha: 1)
		cell.imageView?.clipsToBounds = true
		presenter.getImageDataForCell(at: indexPath, callBack: { data in
			let image = UIImage(data: data)
			cell.imageView?.image = image
			cell.layoutSubviews()
			guard let height = cell.imageView?.bounds.size.height else { return }
			cell.imageView?.image = cell.imageView?.image?.imageWithImage(scaledToSize: CGSize(width: height, height: height))
			cell.imageView?.layer.cornerRadius = height / 2
		})
		return cell
	}
}
extension MainScreenViewController: UITableViewDelegate
{
	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		tableView.keyboardDismissMode = .onDrag
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetail(at: indexPath)
	}
}
// MARK: - UISearchBarDelegate
extension MainScreenViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, text.isEmpty == false else { return }
		presenter.getData(text: text)
		searchBar.placeholder = text
		self.searchController.searchBar.endEditing(true)
		searchController.isActive = false
	}
}
extension MainScreenViewController: IMainScreen
{
	func startLoading() {
		self.notFoundImageView.hideImageView()
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		self.tableView.isHidden = true
		self.view.showActivityIndicatory(containerAcitivtyIndicator: containerView,
										 loadingView: loadingView,
										 activityIndicator: activityIndicator)
	}

	func finishLoading() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		self.tableView.isHidden = false
		self.tableView.reloadData()
		self.activityIndicator.stopAnimating()
		self.activityIndicator.removeFromSuperview()
		self.loadingView.removeFromSuperview()
		self.containerView.removeFromSuperview()
	}

	func setEmptyResult(text: String) {
		self.finishLoading()
		notFoundImageView.showImageView(subview: self.view, text: text)
	}
}
