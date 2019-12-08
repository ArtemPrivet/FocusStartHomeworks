//
//  ComicsViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

final class ComicsViewController: ObjectsListViewController
{
	let presenter: IComicsPresenter

	init(presenter: IComicsPresenter) {
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
		tableView.delegate = self
		view.backgroundColor = .white
		title = "📕Comics"
		tabBarItem = UITabBarItem(title: "Comics", image: #imageLiteral(resourceName: "comic"), tag: 2)
	}
}

extension ComicsViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		presenter.setupView(with: searchBar.text)
		updateData()
	}
}

extension ComicsViewController: UISearchResultsUpdating
{
	func updateSearchResults(for searchController: UISearchController) {
		if let text = searchController.searchBar.text, text.isEmpty {
			presenter.setupView(with: nil)
			updateData()
		}
	}
}

extension ComicsViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getComicsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
			UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		let comics = presenter.getComics(index: indexPath.row)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = comics.title
		cell.detailTextLabel?.textColor = .gray
		if let description = comics.description {
			cell.detailTextLabel?.text = description.isEmpty ? "No info" : description
		}
		presenter.getComicsImage(index: indexPath.row)
		return cell
	}
}

extension ComicsViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetailComics(index: indexPath.row)
	}
}
