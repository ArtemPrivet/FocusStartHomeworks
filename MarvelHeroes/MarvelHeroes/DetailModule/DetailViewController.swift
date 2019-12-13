//
//  DetailViewController.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/2/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class DetailViewController: UIViewController
{

	private let presenter: IDetailPresenter
	private var comics = [ResultBook]()
	private let cellIdentifier = "comicsCell"
	private let heroName = UILabel()
	private let gradient = CAGradientLayer()
	private let heroDescription = UITextView()
	private let heroComicsTableView = UITableView()
	private var heroImage = UIImageView()

	init(presenter: IDetailPresenter) {
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
		view.backgroundColor = .white
		view.addSubview(heroImage)
		view.addSubview(heroName)
		view.addSubview(heroDescription)
		view.addSubview(heroComicsTableView)
		setGradient()
		setConstraints()
		heroComicsTableView.dataSource = self
	}
	private func setCell(of index: Int) -> UITableViewCell {
		let cell = UITableView().dequeueReusableCell(withIdentifier: cellIdentifier) ??
			UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
		let comic = comics[index]
		cell.textLabel?.text = comic.title
		cell.imageView?.clipsToBounds = true
		DispatchQueue(label: "loadImage", qos: .userInitiated, attributes: .concurrent).async {
			if let url = URL(string: "\(comic.thumbnail.path)/portrait_small.\(comic.thumbnail.thumbnailExtension)"){
				let heroDataImage = try? Data(contentsOf: url)
				DispatchQueue.main.async {
					if let image = heroDataImage {
						cell.imageView?.image = UIImage(data: image)
						cell.layoutSubviews()
					}
				}
			}
		}
		return cell
	}

	private func setupUI() {
		heroName.isOpaque = false
		heroName.numberOfLines = 0
		heroName.font = UIFont(name: "Helvetica", size: 34)
		heroDescription.backgroundColor = .clear
		heroDescription.isEditable = false
		heroDescription.font = UIFont(name: "Helvetica", size: 18)
		heroName.text = presenter.getHero().name
		heroName.backgroundColor = .clear
		heroDescription.text = presenter.getHero().resultDescription
		heroImage.image = presenter.getImage()
	}

	private func setGradient() {
		gradient.colors = [ #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 0.4869702483).cgColor, #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1).cgColor]
		heroImage.layer.addSublayer(gradient)
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradient.frame = CGRect(x: 0, y: 0, width: heroImage.frame.width, height: heroImage.frame.height + 6)
	}

	private func setConstraints() {
		heroImage.translatesAutoresizingMaskIntoConstraints = false
		heroDescription.translatesAutoresizingMaskIntoConstraints = false
		heroName.translatesAutoresizingMaskIntoConstraints = false
		heroComicsTableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			heroName.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8),
			heroName.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 8),
			heroName.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			heroDescription.topAnchor.constraint(equalTo: heroName.bottomAnchor, constant: 8),
			heroDescription.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
			heroDescription.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			heroDescription.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 1 / 3),
			heroComicsTableView.topAnchor.constraint(equalTo: heroDescription.bottomAnchor, constant: 6),
			heroComicsTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
			heroComicsTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
			heroComicsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			heroImage.topAnchor.constraint(equalTo: self.view.topAnchor),
			heroImage.leftAnchor.constraint(equalTo: self.view.leftAnchor),
			heroImage.rightAnchor.constraint(equalTo: self.view.rightAnchor),
			heroImage.bottomAnchor.constraint(equalTo: heroDescription.bottomAnchor),
		])
	}
}

extension DetailViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.countComics()
	}
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = setCell(of: indexPath.row)
		cell.layoutSubviews()
		return cell
	}
}

extension DetailViewController: IComicView
{
	func show(comics: [ResultBook]) {
		self.comics = comics
		self.heroComicsTableView.reloadData()
	}
}
