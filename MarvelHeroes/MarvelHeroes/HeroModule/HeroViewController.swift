//
//  HeroViewController.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/2/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class HeroViewController: UIViewController
{
	private let presenter: IHeroPresenter
	private var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
	private var heroes = [ResultChar]()
	private let cellIdentifier = "heroCell"
	private let searchBar = UISearchBar()
	private let tableView = UITableView()
	private let request = String()
	private let stubText = UITextView()
	private let stubImage = UIImageView()

	init(presenter: IHeroPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		setupUI()
		addSubviews()
		setConstraints()
		addDelegate()
	}

	private func addDelegate() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.keyboardDismissMode = .onDrag
		searchBar.delegate = self
	}
	private func addSubviews() {
		view.addSubview(searchBar)
		view.addSubview(tableView)
		view.addSubview(stubImage)
		view.addSubview(stubText)
		view.addSubview(activityIndicator)
	}
	private func setupUI() {
		self.title = "Heroes"
		view.backgroundColor = .white
		navigationController?.navigationBar.prefersLargeTitles = true
		title = "🦸‍♂️ Heroes"
		stubImage.image = UIImage(named: "search_stub")
		stubImage.contentMode = .scaleAspectFit
		stubText.text = Constant.stub
		tableView.isHidden = true
		stubText.isHidden = true
		stubText.textAlignment = .center
		stubText.textColor = .gray
		activityIndicator.color = .black
	}

	private func setConstraints() {
		searchBar.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		stubImage.translatesAutoresizingMaskIntoConstraints = false
		stubText.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
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
			stubImage.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3),
			stubText.topAnchor.constraint(equalTo: stubImage.bottomAnchor, constant: 8),
			stubText.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
			stubText.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3),
			stubText.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 1 / 2),
			activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
		])
	}

	private func setCell(index: Int) -> UITableViewCell {
		let hero = heroes[index]
		let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ??
		UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
		cell.imageView?.image = presenter.getImage(of: index)
		cell.imageView?.contentMode = .scaleAspectFit
		cell.imageView?.clipsToBounds = true
		cell.textLabel?.text = hero.name
		cell.detailTextLabel?.text = hero.resultDescription.isEmpty ? "No info" : hero.resultDescription
		cell.imageView?.layer.masksToBounds = true
		cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
		return cell
	}

	private func checkResult(didRecieved: Bool) {
		if didRecieved {
			self.tableView.isHidden = true
			self.stubImage.isHidden = false
			self.stubText.isHidden = false
			self.stubText.text = "Nothing found on query \(searchBar.text ?? "")"
			self.activityIndicator.stopAnimating()
		}
		else {
			self.tableView.isHidden = false
			self.stubImage.isHidden = true
			self.stubText.isHidden = true
			self.activityIndicator.stopAnimating()
		}
	}
}

extension HeroViewController: UITableViewDataSource, UITableViewDelegate
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return heroes.count
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = setCell(index: indexPath.row)
		cell.layoutSubviews()
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		searchBar.resignFirstResponder()
		presenter.showDetail(of: indexPath.row)
	}
}

extension HeroViewController: UISearchBarDelegate
{
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, text.isEmpty == false else { return }
		self.presenter.getHeroes(of: text)
		activityIndicator.startAnimating()
	}
}

extension HeroViewController: IHeroView
{
	func show(heroes: [ResultChar]) {
		self.heroes = heroes
		checkResult(didRecieved: heroes.isEmpty)
		self.tableView.reloadData()
	}
}
