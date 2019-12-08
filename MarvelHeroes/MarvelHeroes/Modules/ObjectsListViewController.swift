//
//  ObjectsListViewController.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 08.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IObjectsListViewController: AnyObject
{
	func updateData()
	func stopActivityIndicator()
	func updateTableViewCell(index: Int, image: UIImage)
	func showAlert(error: Error)
}
// swiftlint:disable:next required_final
class ObjectsListViewController: UIViewController
{
	let tableView = UITableView()
	let searchController = UISearchController(searchResultsController: nil)
	let reuseIdentifier = "cell"

	private let searchStubView = UIImageView(image: #imageLiteral(resourceName: "search_stub"))
	private let searchStubLabel = UILabel()
	private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		setupSubViews()
		setupConstraints()
		setupNavigationBar()
		setupsearchController()
		view.backgroundColor = .white
	}

	private func setupsearchController() {
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Enter character name"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	private func setupSubViews() {
		view.addSubview(tableView)
		view.addSubview(searchStubView)
		view.addSubview(activityIndicator)
		activityIndicator.color = .black
		tableView.tableFooterView = UIView()
		searchStubView.contentMode = .center
		searchStubView.addSubview(searchStubLabel)
		searchStubLabel.text = "Nothing found of query"
		searchStubLabel.textColor = .gray
		searchStubLabel.numberOfLines = 0
		searchStubLabel.textAlignment = .center
		tableView.isHidden = true
		activityIndicator.startAnimating()
	}

	func checkRequestResult(isEmpty: Bool) {
		if isEmpty {
			tableView.isHidden = true
			searchStubView.isHidden = false
			searchStubLabel.text = "Nothing found of query \"\(searchController.searchBar.text ?? "")\""
		}
		else {
			tableView.isHidden = false
			searchStubView.isHidden = true
		}
	}

	private func setupConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		searchStubView.translatesAutoresizingMaskIntoConstraints = false
		searchStubLabel.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

			searchStubView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			searchStubView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			searchStubView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			searchStubView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

			searchStubLabel.centerXAnchor.constraint(equalTo: searchStubView.centerXAnchor),
			searchStubLabel.centerYAnchor.constraint(equalTo: searchStubView.centerYAnchor, constant: 100),
			searchStubLabel.widthAnchor.constraint(equalToConstant: 300),

			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
			])
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesSearchBarWhenScrolling = false
		title = "🦸‍♂️Heroes"
		tabBarItem = UITabBarItem(title: "Heroes", image: #imageLiteral(resourceName: "shield"), tag: 1)
	}
}

extension ObjectsListViewController: IObjectsListViewController
{
	func showAlert(error: Error) {
		let alert = UIAlertController(title: "Load error",
									  message: error.localizedDescription,
									  preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK",
									  style: UIAlertAction.Style.default))
		self.present(alert, animated: true, completion: nil)
	}

	func updateTableViewCell(index: Int, image: UIImage) {
		guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
		cell.imageView?.image = image
		cell.imageView?.clipsToBounds = true
		if let with = cell.imageView?.bounds.width {
			cell.imageView?.layer.cornerRadius = with / 2
		}
		cell.layoutSubviews()
	}

	func stopActivityIndicator() {
		activityIndicator.stopAnimating()
	}

	func updateData() {
		tableView.reloadData()
	}
}
