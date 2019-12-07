//
//  AuthorsView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class AuthorsView: UIViewController
{
	private var authorsPresenter: IAuthorsPresenter

	init(authorsPresenter: IAuthorsPresenter) {
		self.authorsPresenter = authorsPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let tableView = UITableView()
	private let activityIndicator = UIActivityIndicatorView(style: .gray)
	private let imageViewAuthorsNotFound = UIImageView()
	private let labelAuthorsNotFound = UILabel()
	private let searchController = UISearchController(searchResultsController: nil)

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.settingsForNavigationBar()
		self.settingsForSearchController()
		self.setupTableView()
		self.settingsForTableView()
		self.setupActivityInticator()
		self.setupImageViewAuthorsNotFound()
		self.setupLabelAuthorsNotFound()
		self.loadAuthors(withAuthorName: nil)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.prefersLargeTitles = true
		if let indexPath = self.tableView.indexPathForSelectedRow{
			let selectedCell = self.tableView.cellForRow(at: indexPath) as? AuthorsTableViewCell
			selectedCell?.authorNameLabel.textColor = .black
			selectedCell?.backgroundColor = .white
		}
	}

	func settingsForNavigationBar() {
		self.navigationItem.searchController = searchController
		self.navigationController?.navigationBar.topItem?.title = "👨🏼‍🏫Authors"
	}

	func settingsForSearchController() {
		self.searchController.searchBar.delegate = self
		self.searchController.obscuresBackgroundDuringPresentation = false
		self.definesPresentationContext = true
	}

	func setupTableView() {
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.view.addSubview(self.tableView)
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.tableView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
			self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.tableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
			])
	}

	func settingsForTableView() {
		self.tableView.register(AuthorsTableViewCell.self,
								forCellReuseIdentifier: AuthorsTableViewCell.cellReuseIdentifier)
		self.tableView.tableFooterView = UIView(frame: .zero)
		self.tableView.separatorInset.left = 0
		self.tableView.separatorColor = .gray
	}

	func setupActivityInticator() {
		self.view.addSubview(self.activityIndicator)
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.activityIndicator.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.activityIndicator.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
		])
	}

	func setupImageViewAuthorsNotFound() {
		self.view.addSubview(self.imageViewAuthorsNotFound)
		self.imageViewAuthorsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.imageViewAuthorsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.imageViewAuthorsNotFound.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
			self.imageViewAuthorsNotFound.heightAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
			self.imageViewAuthorsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
			])
		self.imageViewAuthorsNotFound.image = UIImage(named: "search_stub")
		self.imageViewAuthorsNotFound.isHidden = true
	}

	func setupLabelAuthorsNotFound() {
		self.view.addSubview(self.labelAuthorsNotFound)
		self.labelAuthorsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.labelAuthorsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.labelAuthorsNotFound.topAnchor.constraint(equalTo: self.imageViewAuthorsNotFound.bottomAnchor,
														  constant: Insets.topInsetLabelHeroesNotFound),
			self.labelAuthorsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
		])
		self.labelAuthorsNotFound.numberOfLines = 0
		self.labelAuthorsNotFound.textAlignment = .center
		self.labelAuthorsNotFound.font = UIFont(name: "Helvetica", size: 20)
		self.labelAuthorsNotFound.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		self.labelAuthorsNotFound.isHidden = true
	}

	func loadAuthors(withAuthorName name: String?) {
		self.authorsPresenter.getAuthors(withAuthorName: name)
		self.imageViewAuthorsNotFound.isHidden = true
		self.labelAuthorsNotFound.isHidden = true
		self.tableView.isHidden = true
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
	}
}

extension AuthorsView: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? AuthorsTableViewCell
		selectedCell?.authorNameLabel.textColor = .white
		selectedCell?.backgroundColor = #colorLiteral(red: 0.846742928, green: 0.1176741496, blue: 0, alpha: 1)
		guard let author = self.authorsPresenter.getAuthor(at: indexPath.row) else { return }
		self.authorsPresenter.onCellPressed(author: author)
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? AuthorsTableViewCell
		highlightedCell?.authorNameLabel.textColor = .white
		highlightedCell?.backgroundColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? AuthorsTableViewCell
		highlightedCell?.authorNameLabel.textColor = .black
		highlightedCell?.backgroundColor = .white
	}
}

extension AuthorsView: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.authorsPresenter.getAuthorsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: AuthorsTableViewCell.cellReuseIdentifier)
			as? AuthorsTableViewCell
		let author = self.authorsPresenter.getAuthor(at: indexPath.row)

		if let fullName = author?.fullName, fullName.isEmpty == false {
			cell?.authorNameLabel.text = fullName
		}
		else {
			cell?.authorNameLabel.text = "Noname"
		}

		if let authorImageData = self.authorsPresenter.getAuthorImageData(at: indexPath.row) {
			cell?.authorImageView.image = UIImage(data: authorImageData)
		}

		return cell ?? UITableViewCell(style: .default, reuseIdentifier: AuthorsTableViewCell.cellReuseIdentifier)
	}
}

extension AuthorsView: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if self.searchController.searchBar.text?.isEmpty == false {
			let authorName = self.searchController.searchBar.text
			self.loadAuthors(withAuthorName: authorName)
		}
		else {
			self.loadAuthors(withAuthorName: nil)
		}
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.loadAuthors(withAuthorName: nil)
	}
}

extension AuthorsView: IAuthorsView
{
	func reloadData(withAuthorsCount count: Int) {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
		if count == 0 {
			self.imageViewAuthorsNotFound.isHidden = false
			if let text = self.searchController.searchBar.text {
				self.labelAuthorsNotFound.text = "Nothing found on query \"\(text)\""
				self.labelAuthorsNotFound.isHidden = false
			}
		}
		else {
			self.tableView.isHidden = false
		}
		self.tableView.reloadData()
	}
}
