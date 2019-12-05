//
//  HeroViewController.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/2/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

class HeroViewController: UIViewController {
	private let presenter: IHeroPresenter
	private var group = DispatchGroup()
	private var searchBar = UISearchBar()
	private var tableView = UITableView()
	private var stubImage: UIImageView = {
		let view = UIImageView()
		view.contentMode = .scaleAspectFit
		return view
	}()
	private var stubText = UITextView()

	init(presenter: IHeroPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		view.addSubview(searchBar)
		view.addSubview(tableView)
		view.addSubview(stubImage)
		view.addSubview(stubText)
		setConstraints()
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
	}

	private func setupUI() {
		self.title = "Heroes"
		view.backgroundColor = .white
		navigationController?.navigationBar.prefersLargeTitles = true
		navigationItem.title = "🦸‍♂️ Heroes"
		stubImage.image = UIImage(named: "search_stub")
		stubText.text = "Nothing found on query "
		tableView.isHidden = true
		stubText.isHidden = true
		stubText.textAlignment = .center
		stubText.textColor = .gray
	}

	private func setConstraints() {
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		stubImage.translatesAutoresizingMaskIntoConstraints = false
		stubText.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			searchBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
			searchBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
			tableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
			tableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			stubImage.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 40),
			stubImage.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
			stubImage.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3),
			stubText.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
			stubText.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
			stubText.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1/3),
			stubText.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1/2)
		])
	}
}

extension HeroViewController: UISearchBarDelegate {

	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		UIApplication.shared.isNetworkActivityIndicatorVisible = true
			guard let text = searchBar.text, text.isEmpty == false else { return }
			self.presenter.getHeroes(of: text)
			self.tableView.reloadData()
	}
}

extension HeroViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.heroesCount
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		self.tableView.isHidden = false
		stubImage.isHidden = true
		stubText.isHidden = true
		let cell = tableView.dequeueReusableCell(withIdentifier: "heroCell") ?? UITableViewCell(style: .subtitle, reuseIdentifier: "heroCell")
		let hero = presenter.getHero(of: indexPath.row)
		cell.textLabel?.text = hero.name
		if hero.resultDescription.isEmpty {
			cell.detailTextLabel?.text = "No info"
		}
		else {
			cell.detailTextLabel?.text = hero.resultDescription
		}
		cell.imageView?.contentMode = .scaleAspectFit
		cell.imageView?.clipsToBounds = true
		cell.imageView?.layer.cornerRadius = cell.frame.size.height/2
		cell.imageView?.layer.masksToBounds = true
		DispatchQueue.main.async {
			if let url = URL(string: "\(hero.thumbnail.path)/standard_small.\(hero.thumbnail.thumbnailExtension)"){
				if let heroDataImage = try? Data(contentsOf: url){
					cell.imageView?.image = UIImage(data: heroDataImage)
				}
			}
			self.tableView.reloadData()
		}
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.showDetail(of: indexPath.row)
	}
}
