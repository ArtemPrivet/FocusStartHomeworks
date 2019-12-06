//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit
import SnapKit
//decoder.datedecodingstrategy.iso0901 
final class CharactersViewController: UIViewController
{
	let tableView = UITableView()
	private lazy var searchController = UISearchController()
	private let searchStubView = UIImageView()
	private let searchStubLabel = UILabel()
	private let loadIndicator = UIActivityIndicatorView(style: .gray)
	var presenter: ICharactersPresenter?

	override func viewDidLoad() {
		super.viewDidLoad()
		addSubviews()
		configureViews()
		tableView.dataSource = self
		tableView.delegate = self
		searchController.searchResultsUpdater = self
		searchController.obscuresBackgroundDuringPresentation = false
		makeConstraints()
	}
	private func addSubviews() {
		view.addSubview(tableView)
		view.addSubview(searchStubView)
		view.addSubview(searchStubLabel)
	}
	private func configureViews() {
		title = "🦸🏻‍♂️ Heroes"
		tabBarItem = UITabBarItem(title: "Heroes", image: UIImage(named: "shield"), selectedImage: nil)
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = searchController
		tableView.tableFooterView = UIView()
		tableView.backgroundView = loadIndicator
		tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: "cell")
		searchStubView.image = UIImage(named: "search_stub")
		searchStubLabel.numberOfLines = 0
		searchStubLabel.textAlignment = .center
		searchStubLabel.textColor = .gray
		hideError()
	}
	private func makeConstraints() {
		tableView.snp.makeConstraints { maker in
			maker.leading.trailing.top.bottom.equalToSuperview()
		}
		searchStubView.snp.makeConstraints { maker in
			maker.width.equalTo(searchStubView.image?.size.width ?? 0)
			maker.height.equalTo(searchStubView.image?.size.height ?? 0)
			maker.center.equalToSuperview()
		}
		searchStubLabel.snp.makeConstraints { maker in
			maker.leading.equalTo(searchStubView.snp.leading)
			maker.top.equalTo(searchStubView.snp.bottom)
			maker.trailing.equalTo(searchStubView.snp.trailing)
			//maker.bottom.equalToSuperview()
		}
	}
	func showLoadingIndicator() {
		self.loadIndicator.startAnimating()
	}
	func hideLoadingIndicator() {
		self.loadIndicator.stopAnimating()
	}
	func showError(with query: String) {
		searchStubView.isHidden = false
		searchStubLabel.isHidden = false
		searchStubLabel.text = "Nothing found on query \"\(query)\""
	}
	func hideError() {
		searchStubView.isHidden = true
		searchStubLabel.isHidden = true
	}
}
extension CharactersViewController: UITableViewDataSource, UITableViewDelegate
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.getCharacterCount() ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",
													   for: indexPath) as? CharactersTableViewCell
			else { return UITableViewCell() }
		let character = presenter?.getCharacter(by: indexPath.row)
		cell.nameLabel.text = character?.name
		if let description = character?.description {
			if description.isEmpty {
				cell.descriptionLabel.text = "no info"
			}
			else {
				cell.descriptionLabel.text = character?.description
			}
		}
		if let image = character?.thumbnail {
			presenter?.getCharacterImage(for: image, by: indexPath)
		}
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let character = presenter?.getCharacter(by: indexPath.row) else { return }
		presenter?.showDetails(character: character)
	}
}
extension CharactersViewController: UISearchResultsUpdating
{
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text, text.isEmpty == false else { return }
		presenter?.getCharacter(by: text)
	}
}
