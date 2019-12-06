//
//  AuthorDetailsView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 06/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class AuthorDetailsView: UIViewController
{
	var authorDetailsPresenter: IAuthorDetailsPresenter

	init(authorDetailsPresenter: IAuthorDetailsPresenter) {
		self.authorDetailsPresenter = authorDetailsPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	deinit {
		print("AuthorDetailsView deinit")
	}

	let imageView = UIImageView()
	let authorNameLabel = UILabel()
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
		self.setupTableView()
		self.settingsForTableView()
		self.setupActivityInticator()
		self.setupImageViewComicsNotFound()
		self.setupLabelComicsNotFound()
		self.authorDetailsPresenter.loadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if let indexPath = self.tableView.indexPathForSelectedRow{
			let selectedCell = self.tableView.cellForRow(at: indexPath) as? AuthorDetailsTableViewCell
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
		self.view.addSubview(self.authorNameLabel)
		self.authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.authorNameLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
														  constant: Insets.leftInset),
			self.authorNameLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
														   constant: Insets.rightInset),
			self.authorNameLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor,
													  constant: Insets.topInset),
			])
		self.authorNameLabel.font = UIFont(name: "Helvetica-Bold", size: 36)
		self.authorNameLabel.numberOfLines = 0
		self.authorNameLabel.isHidden = true
		if let authorName = self.authorDetailsPresenter.getAuthorName(), authorName.isEmpty == false {
			self.authorNameLabel.text = authorName
		}
		else {
			self.authorNameLabel.text = "No name"
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
		self.tableView.register(AuthorDetailsTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
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

extension AuthorDetailsView: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? AuthorDetailsTableViewCell
		selectedCell?.comicTitleLabel.textColor = .white
		selectedCell?.backgroundColor = #colorLiteral(red: 0.846742928, green: 0.1176741496, blue: 0, alpha: 1)
		guard let comic = self.authorDetailsPresenter.getComic(at: indexPath.row) else { return }
		self.authorDetailsPresenter.pressOnCell(withComic: comic)
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? AuthorDetailsTableViewCell
		highlightedCell?.comicTitleLabel.textColor = .white
		highlightedCell?.backgroundColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? AuthorDetailsTableViewCell
		highlightedCell?.comicTitleLabel.textColor = .black
		highlightedCell?.backgroundColor = .white
	}
}

extension AuthorDetailsView: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.authorDetailsPresenter.getComicsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier) as? AuthorDetailsTableViewCell

		cell?.comicTitleLabel.text = self.authorDetailsPresenter.getComicTitle(at: indexPath.row)
		if let data = self.authorDetailsPresenter.getComicImage(at: indexPath.row) {
			cell?.comicImageView.image = UIImage(data: data)
		}

		return cell ?? UITableViewCell(style: .default, reuseIdentifier: self.cellReuseIdentifier)
	}
}
extension AuthorDetailsView: IAuthorDetailsView
{
	func showData(withImageData data: Data?, withComicsCount count: Int) {
		self.authorNameLabel.isHidden = false
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
