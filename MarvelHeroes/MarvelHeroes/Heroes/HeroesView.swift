//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class HeroesView: UIViewController
{
	private var heroesPresenter: IHeroesPresenter

	init(heroesPresenter: IHeroesPresenter) {
		self.heroesPresenter = heroesPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let tableView = UITableView()
	private let activityIndicator = UIActivityIndicatorView(style: .gray)
	private let imageViewHeroesNotFound = UIImageView()
	private let labelHeroesNotFound = UILabel()
	private let searchController = UISearchController(searchResultsController: nil)

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.settingsForNavigationBar()
		self.settingsForSearchController()
		self.setupTableView()
		self.settingsForTableView()
		self.setupActivityInticator()
		self.setupImageViewHeroesNotFound()
		self.setupLabelHeroesNotFound()
		self.loadHeroes(withHeroeName: nil)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.navigationController?.navigationBar.prefersLargeTitles = true
		if let indexPath = self.tableView.indexPathForSelectedRow{
			let selectedCell = self.tableView.cellForRow(at: indexPath) as? HeroesTableViewCell
			selectedCell?.heroeNameLabel.textColor = .black
			selectedCell?.heroeDescriptionLabel.textColor = .lightGray
			selectedCell?.backgroundColor = .white
		}
	}

	func settingsForNavigationBar() {
		self.navigationItem.searchController = searchController
		self.navigationController?.navigationBar.topItem?.title = "🦸🏼‍♂️Heroes"
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
		self.tableView.register(HeroesTableViewCell.self,
								forCellReuseIdentifier: HeroesTableViewCell.cellReuseIdentifier)
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
		self.view.addSubview(self.imageViewHeroesNotFound)
		self.imageViewHeroesNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.imageViewHeroesNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.imageViewHeroesNotFound.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
			self.imageViewHeroesNotFound.heightAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
			self.imageViewHeroesNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
		])
		self.imageViewHeroesNotFound.image = UIImage(named: "search_stub")
		self.imageViewHeroesNotFound.isHidden = true
	}

	func setupLabelHeroesNotFound() {
		self.view.addSubview(self.labelHeroesNotFound)
		self.labelHeroesNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.labelHeroesNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.labelHeroesNotFound.topAnchor.constraint(equalTo: self.imageViewHeroesNotFound.bottomAnchor,
														  constant: Insets.topInsetLabelHeroesNotFound),
			self.labelHeroesNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewHeroesNotFound),
		])
		self.labelHeroesNotFound.numberOfLines = 0
		self.labelHeroesNotFound.textAlignment = .center
		self.labelHeroesNotFound.font = UIFont(name: "Helvetica", size: 20)
		self.labelHeroesNotFound.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		self.labelHeroesNotFound.isHidden = true
	}

	func loadHeroes(withHeroeName name: String?) {
		self.heroesPresenter.getHeroes(withHeroeName: name)
		self.imageViewHeroesNotFound.isHidden = true
		self.labelHeroesNotFound.isHidden = true
		self.tableView.isHidden = true
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
	}
}

extension HeroesView: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? HeroesTableViewCell
		selectedCell?.heroeNameLabel.textColor = .white
		selectedCell?.heroeDescriptionLabel.textColor = .white
		selectedCell?.backgroundColor = #colorLiteral(red: 0.846742928, green: 0.1176741496, blue: 0, alpha: 1)
		guard let heroe = self.heroesPresenter.getHeroe(at: indexPath.row) else { return }
		self.heroesPresenter.onCellPressed(heroe: heroe)
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? HeroesTableViewCell
		highlightedCell?.heroeNameLabel.textColor = .white
		highlightedCell?.heroeDescriptionLabel.textColor = .white
		highlightedCell?.backgroundColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? HeroesTableViewCell
		highlightedCell?.heroeNameLabel.textColor = .black
		highlightedCell?.heroeDescriptionLabel.textColor = .lightGray
		highlightedCell?.backgroundColor = .white
	}
}

extension HeroesView: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.heroesPresenter.getHeroesCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: HeroesTableViewCell.cellReuseIdentifier)
			as? HeroesTableViewCell
		let character = self.heroesPresenter.getHeroe(at: indexPath.row)

		if let name = character?.name, name.isEmpty == false {
			cell?.heroeNameLabel.text = name
		}
		else {
			cell?.heroeNameLabel.text = "Noname"
		}

		if let description = character?.resultDescription, description.isEmpty == false {
			cell?.heroeDescriptionLabel.text = description
		}
		else {
			cell?.heroeDescriptionLabel.text = "No info"
		}

		if let heroeImageData = self.heroesPresenter.getHeroeImageData(at: indexPath.row) {
			cell?.heroeImageView.image = UIImage(data: heroeImageData)
		}

		return cell ?? UITableViewCell(style: .default, reuseIdentifier: HeroesTableViewCell.cellReuseIdentifier)
	}
}

extension HeroesView: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		if self.searchController.searchBar.text?.isEmpty == false {
			let heroeName = self.searchController.searchBar.text
			self.loadHeroes(withHeroeName: heroeName)
		}
		else {
			self.loadHeroes(withHeroeName: nil)
		}
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		self.loadHeroes(withHeroeName: nil)
	}
}

extension HeroesView: IHeroesView
{
	func reloadData(withHeroesCount count: Int) {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.isHidden = true
		if count == 0 {
			self.imageViewHeroesNotFound.isHidden = false
			if let text = self.searchController.searchBar.text {
				self.labelHeroesNotFound.text = "Nothing found on query \"\(text)\""
				self.labelHeroesNotFound.isHidden = false
			}
		}
		else {
			self.tableView.isHidden = false
		}
		self.tableView.reloadData()
	}
}
