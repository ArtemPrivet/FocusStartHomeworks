//
//  HeroeDetailsView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 03/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class HeroeDetailsView: UIViewController
{
	var heroeDetailsPresenter: IHeroeDetailsPresenter

	init(heroeDetailsPresenter: IHeroeDetailsPresenter) {
		self.heroeDetailsPresenter = heroeDetailsPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print("HeroeDetailsView deinit")
	}

	let imageView = UIImageView()
	let heroeNameLabel = UILabel()
	let heroeDescriptionLabel = UILabel()
	let gradient = CAGradientLayer()
	let activityIndicator = UIActivityIndicatorView(style: .gray)
	let tableView = UITableView()
	let imageViewComicsNotFound = UIImageView()
	let labelComicsNotFound = UILabel()
	let cellReuseIdentifier = "cell"

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.settingsForNavigationBar()
		self.setupImageView()
		self.setupNameLabel()
		self.setupDescriptionLabel()
		self.setupTableView()
		self.settingsForTableView()
		self.setupActivityInticator()
		self.setupImageViewComicsNotFound()
		self.setupLabelComicsNotFound()
		self.heroeDetailsPresenter.loadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let indexPath = self.tableView.indexPathForSelectedRow{
			let selectedCell = self.tableView.cellForRow(at: indexPath) as? HeroeDetailsTableViewCell
			selectedCell?.comicTitleLabel.textColor = .black
			selectedCell?.backgroundColor = .white
		}
	}

	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.imageView.frame.size.width,
								height: self.imageView.frame.size.height)
	}

	func settingsForNavigationBar() {
		self.navigationController?.navigationBar.prefersLargeTitles = false
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
	}

	func setupImageView() {
		self.view.addSubview(self.imageView)
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.imageView.topAnchor.constraint(equalTo: self.view.topAnchor),
			self.imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.imageView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.50),
		])
		self.imageView.clipsToBounds = true
		self.imageView.contentMode = .scaleAspectFill
		self.setupGradient()
	}

	func setupGradient() {
		gradient.colors = [
			UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor,
			UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor,
		]
		gradient.locations = [0.0, 1.0]
		gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
		gradient.endPoint = CGPoint(x: 0.0, y: 1.0)

		self.imageView.layer.insertSublayer(gradient, at: 0)
	}

	func setupNameLabel() {
		self.view.addSubview(self.heroeNameLabel)
		self.heroeNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.heroeNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
														 constant: Insets.leftInset),
			self.heroeNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
														  constant: Insets.rightInset),
			self.heroeNameLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor,
													 constant: Insets.topInset),
		])
		self.heroeNameLabel.font = UIFont(name: "Helvetica-Bold", size: 36)
		self.heroeNameLabel.numberOfLines = 0
		self.heroeNameLabel.isHidden = true
		if let heroeName = self.heroeDetailsPresenter.getHeroeName(), heroeName.isEmpty == false {
			self.heroeNameLabel.text = heroeName
		}
		else {
			self.heroeNameLabel.text = "No name"
		}
	}

	func setupDescriptionLabel() {
		self.view.addSubview(self.heroeDescriptionLabel)
		self.heroeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.heroeDescriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
														 constant: Insets.leftInset),
			self.heroeDescriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
														  constant: Insets.rightInset),
			self.heroeDescriptionLabel.topAnchor.constraint(equalTo: self.heroeNameLabel.bottomAnchor,
													 constant: Insets.topInset),
			self.heroeDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.imageView.bottomAnchor,
															constant: Insets.bottomInset),
			])
		self.heroeDescriptionLabel.font = UIFont(name: "Helvetica", size: 22)
		self.heroeDescriptionLabel.numberOfLines = 0
		self.heroeDescriptionLabel.isHidden = true
		if let heroeDescription = self.heroeDetailsPresenter.getHeroeDescription(), heroeDescription.isEmpty == false {
			self.heroeDescriptionLabel.text = heroeDescription
		}
		else {
			self.heroeDescriptionLabel.text = "No description."
		}
	}

	func setupTableView() {
		self.tableView.delegate = self
		self.tableView.dataSource = self
		self.view.addSubview(self.tableView)
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.tableView.topAnchor.constraint(equalTo: self.imageView.bottomAnchor),
			self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.tableView.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
			])
	}

	func settingsForTableView() {
		self.tableView.register(HeroeDetailsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
		self.tableView.tableFooterView = UIView(frame: .zero)
		self.tableView.tableHeaderView = UIView(frame: .zero)
		self.tableView.separatorInset.left = 0
		self.tableView.separatorColor = .gray
		self.tableView.isHidden = true
	}

	func setupActivityInticator() {
		self.view.addSubview(self.activityIndicator)
		self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
			self.activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
		])
		self.activityIndicator.isHidden = false
		self.activityIndicator.startAnimating()
	}

	func setupImageViewComicsNotFound() {
		self.view.addSubview(self.imageViewComicsNotFound)
		self.imageViewComicsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.imageViewComicsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.imageViewComicsNotFound.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
			self.imageViewComicsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewComicsNotFound),
			self.imageViewComicsNotFound.heightAnchor.constraint(equalToConstant: Size.imageViewComicsNotFound),
		])
		self.imageViewComicsNotFound.image = UIImage(named: "no_comics")
		self.imageViewComicsNotFound.isHidden = true
	}

	func setupLabelComicsNotFound() {
		self.view.addSubview(self.labelComicsNotFound)
		self.labelComicsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.labelComicsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.labelComicsNotFound.topAnchor.constraint(equalTo: self.imageViewComicsNotFound.bottomAnchor,
														  constant: Insets.topInsetLabelComicsNotFound),
			self.labelComicsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewComicsNotFound),
			])
		self.labelComicsNotFound.text = "Comics not found"
		self.labelComicsNotFound.numberOfLines = 0
		self.labelComicsNotFound.textAlignment = .center
		self.labelComicsNotFound.font = UIFont(name: "Helvetica", size: 18)
		self.labelComicsNotFound.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		self.labelComicsNotFound.isHidden = true
	}
}

extension HeroeDetailsView: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? HeroeDetailsTableViewCell
		selectedCell?.comicTitleLabel.textColor = .white
		selectedCell?.backgroundColor = #colorLiteral(red: 0.846742928, green: 0.1176741496, blue: 0, alpha: 1)
		guard let comic = self.heroeDetailsPresenter.getComic(at: indexPath.row) else { return }
		self.heroeDetailsPresenter.pressOnCell(withComic: comic)
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? HeroeDetailsTableViewCell
		highlightedCell?.comicTitleLabel.textColor = .white
		highlightedCell?.backgroundColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? HeroeDetailsTableViewCell
		highlightedCell?.comicTitleLabel.textColor = .black
		highlightedCell?.backgroundColor = .white
	}
}

extension HeroeDetailsView: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.heroeDetailsPresenter.getComicsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as?
			HeroeDetailsTableViewCell

		cell?.comicTitleLabel.text = self.heroeDetailsPresenter.getComicTitle(at: indexPath.row)
		if let data = self.heroeDetailsPresenter.getComicImage(at: indexPath.row) {
			cell?.comicImageView.image = UIImage(data: data)
		}

		return cell ?? UITableViewCell(style: .default, reuseIdentifier: self.cellReuseIdentifier)
	}
}
extension HeroeDetailsView: IHeroeDetailsView
{
	func showData(withImageData data: Data?, withComicsCount count: Int) {
		self.heroeNameLabel.isHidden = false
		self.heroeDescriptionLabel.isHidden = false
		if count == 0 {
			self.imageViewComicsNotFound.isHidden = false
			self.labelComicsNotFound.isHidden = false
		}
		else {
			self.tableView.isHidden = false
		}

		self.activityIndicator.isHidden = true
		self.activityIndicator.stopAnimating()
		guard let data = data else { return }
		self.imageView.image = UIImage(data: data)
		self.tableView.reloadData()
	}
}
