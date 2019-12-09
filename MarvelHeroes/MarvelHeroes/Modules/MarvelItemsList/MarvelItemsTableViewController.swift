//
//  MarvelItemsTableViewController.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IMarvelItemsList
{
	var marvelItemType: MarvelItemType { get }

	func setStubView(withImage: Bool, message: String, animated: Bool)
	func reloadSection()
	func removeStubView()
}

final class MarvelItemsTableViewController: UITableViewController
{
	private let searchController: UISearchController
	private let presenter: IMarvelContentPresentable
	let marvelItemType: MarvelItemType
	private var lastSearchText: String?

	init(searchController: UISearchController, presenter: IMarvelContentPresentable, marvelItemType: MarvelItemType) {
		self.searchController = searchController
		self.presenter = presenter
		self.marvelItemType = marvelItemType
		super.init(style: .plain)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationController?.navigationBar.prefersLargeTitles = true
		configureSearchController()
		configureTableView()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		navigationItem.hidesSearchBarWhenScrolling = true
	}

	private func configureSearchController() {
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false
		searchController.searchBar.delegate = self
	}

	private func configureTableView() {
		tableView.register(MarvelItemTableViewCell.self, forCellReuseIdentifier: MarvelItemTableViewCell.identifier)
		tableView.tableFooterView = UIView()
		tableView.setStubView(withImage: false, animated: true)
	}
}

extension MarvelItemsTableViewController: UISearchResultsUpdating
{
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text,
				  text.isEmpty == false
		else { return }

		if lastSearchText == text { return }

		tableView.setStubView(withImage: false, message: "", animated: false)

		//Throttling request
		NSObject.cancelPreviousPerformRequests(withTarget: self,
											   selector: #selector(self.reload(_:)),
											   object: searchController.searchBar)
		perform(#selector(self.reload(_:)), with: searchController.searchBar, afterDelay: 0.7)
	}

	@objc func reload(_ searchBar: UISearchBar) {
		guard let query = searchBar.text,
				  query.trimmingCharacters(in: .whitespaces) != "" else { return }
		presenter.searchForItems(type: marvelItemType, with: query)
		lastSearchText = query
	}
}

extension MarvelItemsTableViewController
{
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return Metrics.rowHeight
	}

	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.itemsCount()
	}

	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		guard let marvelItemCell = tableView.dequeueReusableCell(withIdentifier:
		MarvelItemTableViewCell.identifier) as? MarvelItemTableViewCell else { return UITableViewCell() }

		marvelItemCell.setImage(image: Thumbnail.placeholder)

		switch marvelItemType {
		case .heroes:
			let hero = presenter.getHero(ofIndex: indexPath.row)
			marvelItemCell.setCircleImageView()
			marvelItemCell.imageUrlPath = hero.thumbnail.path
			if marvelItemCell.currentImage === Thumbnail.placeholder {
				presenter.setImageToCell(useIndex: indexPath.row, cell: marvelItemCell)
			}
			marvelItemCell.configure(with: hero)
		case .authors:
			let author = presenter.getAuthor(ofIndex: indexPath.row)
			marvelItemCell.imageUrlPath = author.thumbnail.path
			marvelItemCell.configure(with: author)
			if marvelItemCell.currentImage === Thumbnail.placeholder {
				presenter.setImageToCell(useIndex: indexPath.row, cell: marvelItemCell)
			}
		case .comics:
			let comics = presenter.getComics(ofIndex: indexPath.row)
			marvelItemCell.imageUrlPath = comics.thumbnail.path
			marvelItemCell.configure(with: comics)
			if marvelItemCell.currentImage === Thumbnail.placeholder {
				presenter.setImageToCell(useIndex: indexPath.row, cell: marvelItemCell)
			}
		}

		return marvelItemCell
	}

	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		searchController.searchBar.endEditing(false)
		presenter.onCellPressed(useIndex: indexPath.row)
	}
}

extension MarvelItemsTableViewController: UISearchBarDelegate
{
	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		if presenter.itemsCount() == 0 {
		tableView.setStubView(withImage: false, animated: true)
		}
	}

	func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
		tableView.restore()
	}

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		searchController.dismiss(animated: true)
		guard let query = searchBar.text,
			query.trimmingCharacters(in: .whitespaces) != "" else { return }
		if lastSearchText == query { return }
		presenter.searchForItems(type: marvelItemType, with: query)
	}
}

extension MarvelItemsTableViewController: IMarvelItemsList
{
	func reloadSection() {
		tableView.reloadSections([0], with: .fade)
	}

	func setStubView(withImage: Bool, message: String, animated: Bool) {
		tableView.setStubView(withImage: withImage, message: message, animated: animated)
	}

	func removeStubView() {
		tableView.restore()
	}
}
