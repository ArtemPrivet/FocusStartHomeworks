//
//  MainScreen.swift
//  MarvelHeroes
//
//  Created by Антон on 01.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import UIKit

final class MainScreen: UIViewController
{
	let presenter = HeroesScreenPresenter()
	private let tableView = UITableView()

	private func setupTableView() {
		self.view.addSubview(tableView)
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.tableView.tableFooterView = UIView()
		NSLayoutConstraint.activate([
			self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
			self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
		])
		self.tableView.rowHeight = UITableView.automaticDimension
	}

	private let searchController = UISearchController(searchResultsController: nil)

	private func setupSearchBar() {
		if #available(iOS 11.0, *) {
			searchController.searchBar.placeholder = "Enter the name of hero"
			self.navigationItem.searchController = searchController
			self.navigationItem.hidesSearchBarWhenScrolling = false
		}
		else {
			searchController.searchBar.searchBarStyle = .prominent
			self.tableView.tableHeaderView = searchController.searchBar
		}
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.hidesNavigationBarDuringPresentation = false
	}

	private let activityIndicator = UIActivityIndicatorView()

	private func setupActivityIndicator() {
		self.view.addSubview(activityIndicator)
		activityIndicator.frame = self.view.frame
		activityIndicator.isHidden = true
		activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		let transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
		activityIndicator.transform = transform
	}

	private let notFoundImageView = UIImageView(image: #imageLiteral(resourceName: "search_stub"))
	private let notFoundLabel = UILabel()
	private var verticalStackFromImageAndLabel = UIStackView()

	private func setupNotFoundImageAndLabel() {
		verticalStackFromImageAndLabel = UIStackView(arrangedSubviews: [notFoundImageView, notFoundLabel])
		self.view.addSubview(verticalStackFromImageAndLabel)
		verticalStackFromImageAndLabel.translatesAutoresizingMaskIntoConstraints = false
		verticalStackFromImageAndLabel.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
		verticalStackFromImageAndLabel.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor).isActive = true
		verticalStackFromImageAndLabel.distribution = .equalCentering
		verticalStackFromImageAndLabel.widthAnchor.constraint(lessThanOrEqualToConstant:
			self.view.bounds.width).isActive = true
		verticalStackFromImageAndLabel.spacing = 10
		verticalStackFromImageAndLabel.axis = .vertical
		notFoundLabel.textColor = #colorLiteral(red: 0.4244923858, green: 0.4244923858, blue: 0.4244923858, alpha: 1)
		notFoundLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 18)
		notFoundLabel.numberOfLines = 0
		verticalStackFromImageAndLabel.isHidden = true
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		searchController.searchBar.delegate = self
		title = presenter.mainTitle
		setupTableView()
		setupSearchBar()
		setupActivityIndicator()
		presenter.attachMainScreen(self)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNotFoundImageAndLabel()
	}
}
// MARK: - UISearchBarDelegate
extension MainScreen: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, text.isEmpty == false else { return }
		presenter.getData(characterName: text)
		searchBar.placeholder = text
		self.searchController.searchBar.endEditing(true)
		searchController.isActive = false
	}
}
// MARK: - IMainScreenData
extension MainScreen: IMainScreenData
{
	func startLoading() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
		activityIndicator.isHidden = false
		activityIndicator.startAnimating()
	}

	func finishLoading() {
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		activityIndicator.isHidden = true
		activityIndicator.stopAnimating()
		self.verticalStackFromImageAndLabel.isHidden = true
		self.tableView.isHidden = false
		self.tableView.reloadData()
	}

	func setHeroes(characters: [Character]) {
		self.tableView.reloadData()
	}

	func setEmptyHeroes(characterName: String) {
		self.tableView.reloadData()
		UIApplication.shared.isNetworkActivityIndicatorVisible = false
		self.activityIndicator.isHidden = true
		self.activityIndicator.stopAnimating()
		self.tableView.isHidden = false
		self.verticalStackFromImageAndLabel.isHidden = false
		self.notFoundLabel.text = "Nothing found on query \"\(characterName)\""
	}

	func updateRow(indexPath: IndexPath) {
		self.tableView.beginUpdates()
		self.tableView.reloadRows(at: [indexPath], with: .fade)
		self.tableView.endUpdates()
	}
}
// MARK: - TableViewDelegate, TableViewDataSource
extension MainScreen: UITableViewDelegate, UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.heroesArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = presenter.getHero(indexPath)?.name
		cell.detailTextLabel?.text = presenter.getHero(indexPath)?.description
		cell.detailTextLabel?.textColor = #colorLiteral(red: 0.5406504869, green: 0.5422019362, blue: 0.5556592345, alpha: 1)
		cell.imageView?.clipsToBounds = true
		presenter.getHeroImageData(indexPath) { data in
			DispatchQueue.main.async {
				let image = UIImage(data: data)
				cell.imageView?.image = image
				cell.layoutSubviews()
				guard let height = cell.imageView?.bounds.size.height else { return }
				cell.imageView?.image = cell.imageView?.image?.imageWithImage(scaledToSize: CGSize(width: height, height: height))
				cell.imageView?.layer.cornerRadius = height / 2
			}
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.transitionToDetailScreen(indexPath: indexPath)
	}

	func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
		tableView.keyboardDismissMode = .onDrag
	}
}
