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
	private let searchImage = UIImageView()
	private let searchErrorText = UILabel()
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
		view.addSubview(searchImage)
		view.addSubview(searchErrorText)
	}
	private func configureViews() {
		title = "🦸🏻‍♂️ Heroes"
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.searchController = searchController
		tableView.tableFooterView = UIView()
		tableView.backgroundView = loadIndicator
		tableView.register(CharactersTableViewCell.self, forCellReuseIdentifier: "cell")
		searchImage.image = UIImage(named: "search_stub")
		searchErrorText.numberOfLines = 0
		searchErrorText.textAlignment = .center
		searchErrorText.textColor = .gray
		hideError()
	}
	private func makeConstraints() {
		tableView.snp.makeConstraints { maker in
			maker.leading.trailing.top.bottom.equalToSuperview()
		}
		searchImage.snp.makeConstraints { maker in
			maker.width.equalTo(searchImage.image?.size.width ?? 0)
			maker.height.equalTo(searchImage.image?.size.height ?? 0)
			maker.center.equalToSuperview()
		}
		searchErrorText.snp.makeConstraints { maker in
			maker.leading.equalTo(searchImage.snp.leading)
			maker.top.equalTo(searchImage.snp.bottom)
			maker.trailing.equalTo(searchImage.snp.trailing)
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
		searchImage.isHidden = false
		searchErrorText.isHidden = false
		searchErrorText.text = "Nothing found on query \"\(query)\""
	}
	func hideError() {
		searchImage.isHidden = true
		searchErrorText.isHidden = true
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
