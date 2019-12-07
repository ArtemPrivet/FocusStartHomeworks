//
//  DetailedHeroViewController.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 07/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import UIKit

final class DetailedHeroViewController: UIViewController
{
	var presenter: IDetailedHeroPresenter
	private var heroImageView = UIImageView()
	private var heroNameLabel = UILabel(frame: .zero)
	private var heroDescriptionLabel = UILabel()
	private let tableView = UITableView()
	private var comics: [Comics] = []

	init(presenter: IDetailedHeroPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}

	@available (*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		presenter.delegate = self
		settingsForNavigationBar()
		setupHeroImageView()
		setupHeroNameLabel()
		setupHeroDescriptionLabel()
		setupTableView()
		presenter.getComics(for: presenter.getCharacter())
		presenter.getImage(index: presenter.getCharacter().id)
	}

	func settingsForNavigationBar() {
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}

	private func setupHeroImageView() {
		view.addSubview(heroImageView)
		heroImageView.contentMode = .scaleAspectFill
		heroImageView.translatesAutoresizingMaskIntoConstraints = false
		heroImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		heroImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
		heroImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
	}

	private func setupTableView() {
		tableView.dataSource = self
		view.addSubview(tableView)
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
		tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: self.heroImageView.bottomAnchor).isActive = true
	}

	private func setupHeroNameLabel() {
		view.addSubview(heroNameLabel)
		heroNameLabel.translatesAutoresizingMaskIntoConstraints = false
		heroNameLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 64).isActive = true
		heroNameLabel.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16).isActive = true
		heroNameLabel.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 16).isActive = true
		heroNameLabel.text = presenter.getCharacter().name
		heroNameLabel.numberOfLines = 0
		self.heroNameLabel.font = UIFont(name: "Helvetica-Bold", size: 36)
	}

	private func setupHeroDescriptionLabel() {
		view.addSubview(heroDescriptionLabel)
		heroDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		heroDescriptionLabel.topAnchor.constraint(equalTo: heroNameLabel.bottomAnchor, constant: 16).isActive = true
		heroDescriptionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
		heroDescriptionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 16).isActive = true
		heroImageView.bottomAnchor.constraint(equalTo: heroDescriptionLabel.bottomAnchor, constant: 16).isActive = true
		self.heroDescriptionLabel.font = UIFont(name: "Helvetica", size: 20)
		self.heroDescriptionLabel.numberOfLines = 0
		if presenter.getCharacter().description.isEmpty {
			heroDescriptionLabel.text = "No info"
		}
		else {
			heroDescriptionLabel.text = presenter.getCharacter().description
		}
	}
}

extension DetailedHeroViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return comics.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "comics") ??
			UITableViewCell(style: .subtitle, reuseIdentifier: "comics")
		cell.textLabel?.text = presenter.getCharacter().comics.items[indexPath.row].name
		presenter.getComicsImage(index: indexPath.row)
		return cell
	}
}

extension DetailedHeroViewController: IComicsDelegate
{
	func showHeroImage(_ image: UIImage) {
		self.heroImageView.image = image
	}

	func showComics(comics: [Comics]) {
		self.comics = comics
		self.tableView.reloadData()
	}

	func showComicsImage(_ image: UIImage, index: Int) {
		guard let cell = self.tableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
		cell.imageView?.image = image
		cell.layoutSubviews()
		cell.imageView?.clipsToBounds = true
	}
}
