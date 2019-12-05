//
//  AuthorsViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IAuthorsViewController: class {
	func updateData()
}

class AuthorsViewController: UIViewController {

	let refreshControl = UIRefreshControl()
	
	@objc private func refresh(sender: UIRefreshControl) {
		presenter.setupView(with: nil)
		sender.endRefreshing()
	}
	
	private let searchController = UISearchController(searchResultsController: nil)
	let searchStubView = UIImageView(image: #imageLiteral(resourceName: "search_stub"))
	let searchStubLabel = UILabel()
	let tableView = UITableView()
	var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
	let presenter: IAuthorsPresenter
	
	init(presenter: IAuthorsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		self.activityIndicator.startAnimating()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		setupNavigationBar()
		self.tableView.dataSource = self
		self.tableView.delegate = self
		setupSubViews()
		setupConstraints()
		setupNavigationBar()
		setupsearchController()
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		self.view.backgroundColor = .white
		tableView.refreshControl = refreshControl
	}
	
	private func setupNavigationBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesSearchBarWhenScrolling = false
		let searchController = UISearchController(searchResultsController: nil)
		navigationItem.searchController = searchController
		title = "👨‍🏫Authors"
		tabBarItem = UITabBarItem(title: "Authors", image: #imageLiteral(resourceName: "writer"), tag: 3)
	}
	
	private func setupsearchController() {
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Enter author name"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}

	private func setupSubViews() {
		self.view.addSubview(tableView)
		self.view.addSubview(searchStubView)
		self.view.addSubview(activityIndicator)
		self.activityIndicator.color = .black
		self.tableView.tableFooterView = UIView()
		self.searchStubView.contentMode = .center
		self.searchStubView.addSubview(searchStubLabel)
		self.searchStubLabel.text = "Nothing found of query"
		self.searchStubLabel.textColor = .gray
		self.searchStubLabel.numberOfLines = 0
		self.searchStubLabel.textAlignment = .center
	}
	
	func  checkRequestResult(isEmpty: Bool) {
		if isEmpty {
			self.tableView.isHidden = true
			self.searchStubView.isHidden = false
			self.searchStubLabel.text = "Nothing found of query \"\(searchController.searchBar.text ?? "")\""
		} else {
			self.tableView.isHidden = false
			self.searchStubView.isHidden = true
		}
	}
	
	private func setupConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		searchStubView.translatesAutoresizingMaskIntoConstraints = false
		searchStubLabel.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			
			searchStubView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			searchStubView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			searchStubView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			searchStubView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			
			searchStubLabel.centerXAnchor.constraint(equalTo: searchStubView.centerXAnchor),
			searchStubLabel.centerYAnchor.constraint(equalTo: searchStubView.centerYAnchor,constant: 100),
			searchStubLabel.widthAnchor.constraint(equalToConstant: 300),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			])
	}
}

extension AuthorsViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		presenter.setupView(with: searchBar.text)
		self.updateData()
	}
}

extension AuthorsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if searchController.searchBar.text == "" {
			presenter.setupView(with: nil)
			self.updateData()
		}
	}
}

extension AuthorsViewController: IAuthorsViewController {
	func updateData() {
		self.tableView.reloadData()
	}
}

extension AuthorsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getAuthorsCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "comicsCell") ?? UITableViewCell(style: .default, reuseIdentifier: "comicsCell")
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		let author = presenter.getAuthor(index: indexPath.row)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = author.firstName
		
		presenter.getAuthorImage(index: indexPath.row)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetailAuthor(index: indexPath.row)
	}
}
