//
//  ComicsViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 03.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IComicsViewController: class {
	func updateData()
}

class ComicsViewController: UIViewController {
	
	let refreshControl = UIRefreshControl()
	
	@objc private func refresh(sender: UIRefreshControl) {
		presenter.setupView(with: nil)
		sender.endRefreshing()
	}
	
	private let searchController = UISearchController(searchResultsController: nil)
	let searchStubView = UIImageView(image: #imageLiteral(resourceName: "search_stub"))
	let searchStubLabel = UILabel()
	let tableView = UITableView()
	let presenter: IComicsPresenter
	
	init(presenter: IComicsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
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
		title = "📕Comics"
		tabBarItem = UITabBarItem(title: "Comics", image: #imageLiteral(resourceName: "comic"), tag: 2)

	}
	
	private func setupsearchController() {
		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Enter character name"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	private func setupSubViews() {
		self.view.addSubview(tableView)
		self.view.addSubview(searchStubView)
		self.tableView.tableFooterView = UIView()
		self.searchStubView.contentMode = .center
		self.searchStubView.addSubview(searchStubLabel)
		self.searchStubLabel.text = "Nothing found of query"
		self.searchStubLabel.textColor = .gray
		self.searchStubLabel.numberOfLines = 0
		self.searchStubLabel.textAlignment = .center
//		self.tableView.isHidden = true
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
			])
	}
}

extension ComicsViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		presenter.setupView(with: searchBar.text)
		self.updateData()
	}
}

extension ComicsViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		if searchController.searchBar.text == "" {
			presenter.setupView(with: nil)
			self.updateData()
		}
	}
}


extension ComicsViewController: IComicsViewController {
	func updateData() {
		self.tableView.reloadData()
	}
}
	
extension ComicsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getComicsCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "comicsCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "comicsCell")
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		let comics = presenter.getComics(index: indexPath.row)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = comics.title
		cell.detailTextLabel?.textColor = .gray
		
		cell.detailTextLabel?.text = comics.description == "" || comics.description == nil ? "No info" : comics.description
		presenter.getComicsImage(index: indexPath.row)
		
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetailComics(index: indexPath.row)
	}
}
