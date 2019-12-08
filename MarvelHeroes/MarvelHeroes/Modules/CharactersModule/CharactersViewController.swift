//
//  CharactersViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

final class CharactersViewController: ObjectsListViewController
{
	private let presenter: ICharacterPresenter

	init(presenter: ICharacterPresenter) {
		self.presenter = presenter
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		view.backgroundColor = .white
		title = "🦸‍♂️Heroes"
		tabBarItem = UITabBarItem(title: "Heroes", image: #imageLiteral(resourceName: "shield"), tag: 1)
	}
}

extension CharactersViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		presenter.setupView(with: searchBar.text)
		updateData()
	}
}

extension CharactersViewController: UISearchResultsUpdating
{
	func updateSearchResults(for searchController: UISearchController) {
		if let text = searchController.searchBar.text, text.isEmpty {
			presenter.setupView(with: nil)
			updateData()
		}
	}
}

extension CharactersViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getCharactersCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
			UITableViewCell(style: .subtitle, reuseIdentifier: reuseIdentifier)
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		let character = presenter.getCharacter(index: indexPath.row)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = character.name
		cell.detailTextLabel?.textColor = .gray

		cell.detailTextLabel?.text = character.description.isEmpty ? "No info" : character.description
		presenter.getCharacterImage(index: indexPath.row)
		return cell
	}
}

extension CharactersViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetailCharacter(index: indexPath.row)
	}
}
