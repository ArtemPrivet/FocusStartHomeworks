//
//  CharactersViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol ICharactersViewController: class {
	func updateData()
}

class CharactersViewController: UIViewController {
	
	let refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
		return refreshControl
	}()
	
	@objc private func refresh(sender: UIRefreshControl) {
		presenter.setupView(with: self.searchController.searchBar.text)
		self.updateData()
		sender.endRefreshing()
	}
	
	private let searchController = UISearchController(searchResultsController: nil)
	let tableView = UITableView()
	let presenter: ICharacterPresenter
	
	init(presenter: ICharacterPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.tableView.dataSource = self
		self.tableView.delegate = self
		setupSubViews()
		setupConstraints()
		setupNavigationBar()
		setupsearchController()
		self.view.backgroundColor = .white
		tableView.refreshControl = refreshControl
    }
	
	private func setupsearchController() {
//		searchController.searchResultsUpdater = self
		searchController.searchBar.delegate = self
		searchController.obscuresBackgroundDuringPresentation = false
		searchController.searchBar.placeholder = "Enter character name"
		navigationItem.searchController = searchController
		definesPresentationContext = true
	}
	
	private func setupSubViews() {
		self.view.addSubview(tableView)
	}
	
	private func setupConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			
			tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			])
	}
	
	private func setupNavigationBar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.hidesSearchBarWhenScrolling = false
		title = "🦸‍♂️Heroes"
		tabBarItem = UITabBarItem(title: "Heroes", image: #imageLiteral(resourceName: "shield"), tag: 1)
	}
}

extension CharactersViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		print(searchBar.text)
		presenter.setupView(with: searchBar.text)
		self.updateData()
	}
}


extension CharactersViewController: ICharactersViewController {
	func updateData() {
		self.tableView.reloadData()
	}
}

extension CharactersViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getCharactersCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		let character = presenter.getCharacter(index: indexPath.row)
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = character.name
		cell.detailTextLabel?.textColor = .gray
		
		cell.detailTextLabel?.text = character.description == "" ? "No info" : character.description
		presenter.getCharacterImage(index: indexPath.row)

		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		presenter.showDetailCharacter(index: indexPath.row)
	}
}
