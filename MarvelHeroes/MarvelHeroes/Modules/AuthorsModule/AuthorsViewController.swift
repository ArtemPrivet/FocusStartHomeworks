//
//  AuthorsViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

final class AuthorsViewController: ObjectsListViewController
{
	private let presenter: IAuthorsPresenter

	init(presenter: IAuthorsPresenter) {
		self.presenter = presenter
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.setupView(with: nil)
		tableView.dataSource = self
		tableView.delegate = self
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		view.backgroundColor = .white
		title = "👨‍🏫Authors"
		tabBarItem = UITabBarItem(title: "Authors", image: #imageLiteral(resourceName: "writer"), tag: 3)
	}
}

extension AuthorsViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		presenter.setupView(with: searchBar.text)
		updateData()
	}
}

extension AuthorsViewController: UISearchResultsUpdating
{
	func updateSearchResults(for searchController: UISearchController) {
		if let text = searchController.searchBar.text, text.isEmpty {
			presenter.setupView(with: nil)
			updateData()
		}
	}
}

extension AuthorsViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getAuthorsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
			UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		let author = presenter.getAuthor(index: indexPath.row)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = author.firstName
		cell.detailTextLabel?.textColor = .gray
		cell.detailTextLabel?.text = author.lastName
		presenter.getAuthorImage(index: indexPath.row)
		return cell
	}
}

extension AuthorsViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetailAuthor(index: indexPath.row)
	}
}
