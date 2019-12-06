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
	var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
	private var group = DispatchGroup()
	private var searchBar = UISearchBar()
	private var tableView = UITableView()
	private var request = String()
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

	@available(*, unavailable)
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
		view.addSubview(activityIndicator)
		setConstraints()
		tableView.delegate = self
		tableView.dataSource = self
		searchBar.delegate = self
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		super.touchesBegan(touches, with: event)
		view.endEditing(true)
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

	func checkResult(ifGot: Bool) {
		if ifGot {
			self.tableView.isHidden = false
			self.stubImage.isHidden = true
			self.stubText.isHidden = true
			self.activityIndicator.stopAnimating()
		}
		else {
			self.tableView.isHidden = true
			self.stubImage.isHidden = false
			self.stubText.isHidden = false
			self.stubText.text = "Nothing found on query \(searchBar.text ?? "")"
			self.activityIndicator.stopAnimating()
		}
	}
}

extension HeroViewController: UITableViewDataSource, UITableViewDelegate
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		checkResult(ifGot: presenter.heroesCount != 0)
		return presenter.heroesCount
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "heroCell") ??
			UITableViewCell(style: .subtitle, reuseIdentifier: "heroCell")
		let hero = presenter.getHero(of: indexPath.row)
		print(hero.id)
		cell.textLabel?.text = hero.name
		if hero.resultDescription.isEmpty {
			cell.detailTextLabel?.text = "No info"
		}
		else {
			cell.detailTextLabel?.text = hero.resultDescription
		}
		cell.imageView?.contentMode = .scaleAspectFit
		cell.imageView?.clipsToBounds = true
		cell.imageView?.layer.cornerRadius = cell.frame.size.height / 2
		cell.imageView?.layer.masksToBounds = true
		DispatchQueue(label: "loadImage", qos: .userInitiated, attributes: .concurrent).async {
			if let url = URL(string: "\(hero.thumbnail.path)/standard_medium.\(hero.thumbnail.thumbnailExtension)"){
				let heroDataImage = try? Data(contentsOf: url)
				DispatchQueue.main.async {
					if let image = heroDataImage {
						cell.imageView?.image = UIImage(data: image)
					}
				}
			}
		}
		return cell
	}
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.showDetail(of: indexPath.row)
	}
}

extension HeroViewController: UISearchBarDelegate
{
// проблема с поиском: срабатывает после 2-3 нажатий на сеарчБ плюс картинки подгружаются при скролинге или нажав ячейку
	// КАК ИСПРАВИТЬ???
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		guard let text = searchBar.text, text.isEmpty == false else { return }
		self.presenter.getHeroes(of: text)
		activityIndicator.startAnimating()
		self.tableView.reloadData()
	}
}
