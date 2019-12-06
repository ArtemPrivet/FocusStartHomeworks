//
//  ViewController.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 04/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit

class HeroesViewController: UIViewController {
	
	private var presenter: IHeroesPresenter
	private let searchController = UISearchController(searchResultsController: nil)
	private var timer: Timer?
	private let tableView = UITableView()
	private let searchStubImageView = UIImageView(image: #imageLiteral(resourceName: "search_stub"))
	private let searchStubLabel = UILabel()
	
	init(presenter: IHeroesPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		presenter.delegate = self
		self.navigationController?.navigationBar.topItem?.title = "🦸‍♂️Heroes"
		setupSearchBar()
		setupTableView()
		setupSearchStubs()
		setupConstraints()
		presenter.getCharacters(nil)
	}
	
	private func setupSearchBar() {
		searchController.obscuresBackgroundDuringPresentation = false // позволяет не затемняться бару при поиске
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = false // фиксиурет серчбар
		searchController.searchBar.delegate = self
		searchController.definesPresentationContext = true
	}
	
	private func setupTableView() {
		view.addSubview(tableView)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.tableFooterView = UIView()
	}
	
	private func setupSearchStubs() {
		view.backgroundColor = .white
		view.addSubview(searchStubImageView)
		searchStubImageView.addSubview(searchStubLabel)
		searchStubImageView.contentMode = .center
		searchStubLabel.textColor = .gray
		searchStubLabel.numberOfLines = 0
		searchStubLabel.textAlignment = .center
		searchStubLabel.isHidden = true
		searchStubImageView.isHidden = true
	}
	
	private func setupConstraints() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		searchStubImageView.translatesAutoresizingMaskIntoConstraints = false
		searchStubLabel.translatesAutoresizingMaskIntoConstraints = false
		
		tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
		
		searchStubImageView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
		searchStubImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		searchStubImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		searchStubImageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
		
		searchStubLabel.centerXAnchor.constraint(equalTo: searchStubImageView.centerXAnchor).isActive = true
		searchStubLabel.centerYAnchor.constraint(equalTo: searchStubImageView.centerYAnchor, constant: 100).isActive = true
		searchStubLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
	}
}

extension HeroesViewController: UISearchBarDelegate
{
	func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
		timer?.invalidate()
		timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
			print(searchText)
			self.presenter.getCharacters(searchText)
		})
	}
	
//	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//		searchBar.text = nil
//		searchBar.showsCancelButton = false
//		searchBar.endEditing(true)
//		presenter.getCharacters(nil)
//	}
}

extension HeroesViewController: UITableViewDataSource, UITableViewDelegate
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getCharactersCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "hero") ??
			UITableViewCell(style: .subtitle, reuseIdentifier: "hero")
		let hero = presenter.getCharacter(indexPath.row)
		cell.textLabel?.text = hero.name
		if hero.description.isEmpty {
			cell.detailTextLabel?.text = "No info"
		}
		else {
			cell.detailTextLabel?.text = hero.description
		}

		presenter.getImage(index: indexPath.row)
		return cell
	}
}

extension HeroesViewController: ITableViewDelegate
{
	func reloadTableView() {
		self.tableView.reloadData()
	}
	
	func  checkResultOfRequest(isEmpty: Bool) {
		if isEmpty {
			self.tableView.isHidden = true
			self.searchStubImageView.isHidden = false
			searchStubLabel.isHidden = false
			self.searchStubLabel.text = "Nothing found of query \"\(searchController.searchBar.text ?? "")\""
		}
		else {
			self.tableView.isHidden = false
			self.searchStubLabel.isHidden = true
			self.searchStubImageView.isHidden = true
		}
	}
	
	func updateCellImage(index: Int, image: UIImage) {
		guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
		cell.imageView?.image = image
		cell.layoutSubviews()
		cell.imageView?.clipsToBounds = true
		guard let imageView = cell.imageView else { return }
		cell.imageView?.layer.cornerRadius = imageView.bounds.width / 2
	}
	
}
