//
//  ComicsView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class ComicsViewController: UIViewController
{
	private var comicsPresenter: IComicsPresenter

	init(comicsPresenter: IComicsPresenter) {
		self.comicsPresenter = comicsPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let tableView = UITableView()
	private let activityIndicator = UIActivityIndicatorView(style: .gray)
	private let imageViewComicsNotFound = UIImageView()
	private let labelComicsNotFound = UILabel()
	private let searchController = UISearchController(searchResultsController: nil)

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.settingsForNavigationBar()
		self.settingsForSearchController()
		self.setupTableView()
		self.setupActivityInticator()
		self.setupImageViewHeroesNotFound()
		self.setupLabelHeroesNotFound()
		self.loadComics()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.prefersLargeTitles = true
		self.removeSelectionFromCells()
	}

	func removeSelectionFromCells() {
		if let indexPath = self.tableView.indexPathForSelectedRow{
			let selectedCell = self.tableView.cellForRow(at: indexPath) as? CustomTableViewCell
			selectedCell?.customNameLabel.textColor = .black
			selectedCell?.customDescriptionLabel.textColor = .lightGray
			selectedCell?.backgroundColor = .white
		}
	}

	func settingsForNavigationBar() {
		self.navigationItem.searchController = searchController
		self.navigationController?.navigationBar.topItem?.title = Titles.comicsTitle
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
		self.tableView.register(CustomTableViewCell.self,
								forCellReuseIdentifier: CustomTableViewCell.cellReuseIdentifier)
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

	func setupImageViewHeroesNotFound() {
		self.view.addSubview(self.imageViewComicsNotFound)
		self.imageViewComicsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.imageViewComicsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.imageViewComicsNotFound.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
			self.imageViewComicsNotFound.heightAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
			self.imageViewComicsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
			])
		self.imageViewComicsNotFound.image = UIImage(named: "search_stub")
		self.imageViewComicsNotFound.isHidden = true
	}

	func setupLabelHeroesNotFound() {
		self.view.addSubview(self.labelComicsNotFound)
		self.labelComicsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.labelComicsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.labelComicsNotFound.topAnchor.constraint(equalTo: self.imageViewComicsNotFound.bottomAnchor,
														  constant: Insets.topInsetLabelHeroesNotFound),
			self.labelComicsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
			])
		self.labelComicsNotFound.numberOfLines = 0
		self.labelComicsNotFound.textAlignment = .center
		self.labelComicsNotFound.font = Fonts.helvetica20
		self.labelComicsNotFound.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		self.labelComicsNotFound.isHidden = true
	}

	func loadComics(withComicName name: String? = nil) {
		self.comicsPresenter.getComics(withComicName: name)
		self.imageViewComicsNotFound.isHidden = true
		self.labelComicsNotFound.isHidden = true
		self.tableView.isHidden = true
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
	}
}

extension ComicsViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? CustomTableViewCell
		selectedCell?.customNameLabel.textColor = .white
		selectedCell?.customDescriptionLabel.textColor = .white
		selectedCell?.backgroundColor = #colorLiteral(red: 0.846742928, green: 0.1176741496, blue: 0, alpha: 1)
		guard let comic = self.comicsPresenter.getComic(at: indexPath.row) else { return }
		self.comicsPresenter.onCellPressed(comic: comic)
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? CustomTableViewCell
		highlightedCell?.customNameLabel.textColor = .white
		highlightedCell?.customDescriptionLabel.textColor = .white
		highlightedCell?.backgroundColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? CustomTableViewCell
		highlightedCell?.customNameLabel.textColor = .black
		highlightedCell?.customDescriptionLabel.textColor = .lightGray
		highlightedCell?.backgroundColor = .white
	}
}

extension ComicsViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.comicsPresenter.getComicsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: CustomTableViewCell.cellReuseIdentifier)
			as? CustomTableViewCell
		let comic = self.comicsPresenter.getComic(at: indexPath.row)

		if let title = comic?.title, title.isEmpty == false {
			cell?.customNameLabel.text = title
		}
		else {
			cell?.customNameLabel.text = "Noname"
		}

		if let description = comic?.comicDescription, description.isEmpty == false {
			cell?.customDescriptionLabel.text = description
		}
		else {
			cell?.customDescriptionLabel.text = "No info"
		}

		if let comicImageData = self.comicsPresenter.getComicImageData(at: indexPath.row) {
			cell?.customImageView.image = UIImage(data: comicImageData)
		}

		return cell ?? UITableViewCell(style: .default, reuseIdentifier: CustomTableViewCell.cellReuseIdentifier)
	}
}

extension ComicsViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if self.searchController.searchBar.text?.isEmpty == false {
			let heroeName = self.searchController.searchBar.text
			self.loadComics(withComicName: heroeName)
		}
		else {
			self.loadComics()
		}
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.loadComics()
	}
}

extension ComicsViewController: IComicsView
{
	func reloadData(withComicsCount count: Int) {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
		if count == 0 {
			self.imageViewComicsNotFound.isHidden = false
			if let text = self.searchController.searchBar.text {
				self.labelComicsNotFound.text = "Nothing found on query \"\(text)\""
				self.labelComicsNotFound.isHidden = false
			}
		}
		else {
			self.tableView.isHidden = false
		}
		self.tableView.reloadData()
	}
}
