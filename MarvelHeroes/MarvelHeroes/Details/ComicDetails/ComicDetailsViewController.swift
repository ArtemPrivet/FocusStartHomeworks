//
//  ComicDetailsView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class ComicDetailsViewController: UIViewController
{
	private var comicDetailsPresenter: IComicDetailsPresenter

	init(comicDetailsPresenter: IComicDetailsPresenter) {
		self.comicDetailsPresenter = comicDetailsPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let imageView = UIImageView()
	private let comicTitleLabel = UILabel()
	private let comicDescriptionLabel = UILabel()
	private let gradient = CAGradientLayer()
	private let activityIndicator = UIActivityIndicatorView(style: .gray)
	private let tableView = UITableView()
	private let imageViewAuthorsNotFound = UIImageView()
	private let labelAuthorsNotFound = UILabel()

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		self.settingsForNavigationBar()
		self.setupImageView()
		self.setupTitleLabel()
		self.setupDescriptionLabel()
		self.setupTableView()
		self.setupActivityInticator()
		self.setupImageViewAuthorsNotFound()
		self.setupLabelAuthorsNotFound()
		self.comicDetailsPresenter.loadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.removeSelectionFromCells()
	}

	func removeSelectionFromCells() {
		if let indexPath = self.tableView.indexPathForSelectedRow {
			let selectedCell = self.tableView.cellForRow(at: indexPath) as? DetailsTableViewCell
			selectedCell?.customNameLabel.textColor = .black
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

	func setupTitleLabel() {
		self.view.addSubview(self.comicTitleLabel)
		self.comicTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.comicTitleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
														 constant: Insets.leftInset),
			self.comicTitleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
														  constant: Insets.rightInset),
			self.comicTitleLabel.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor,
													 constant: Insets.topInset),
			])
		self.comicTitleLabel.font = Fonts.helveticaBold36
		self.comicTitleLabel.numberOfLines = 0
		self.comicTitleLabel.isHidden = true
		if let comicTitle = self.comicDetailsPresenter.getComicTitle(), comicTitle.isEmpty == false {
			self.comicTitleLabel.text = comicTitle
		}
		else {
			self.comicTitleLabel.text = "No name"
		}
	}

	func setupDescriptionLabel() {
		self.view.addSubview(self.comicDescriptionLabel)
		self.comicDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.comicDescriptionLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,
																constant: Insets.leftInset),
			self.comicDescriptionLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,
																 constant: Insets.rightInset),
			self.comicDescriptionLabel.topAnchor.constraint(equalTo: self.comicTitleLabel.bottomAnchor,
															constant: Insets.topInset),
			self.comicDescriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: self.imageView.bottomAnchor,
															   constant: Insets.bottomInset),
			])
		self.comicDescriptionLabel.font = Fonts.helvetica22
		self.comicDescriptionLabel.numberOfLines = 0
		self.comicDescriptionLabel.isHidden = true
		if let comicDescription = self.comicDetailsPresenter.getComicDescription(), comicDescription.isEmpty == false {
			self.comicDescriptionLabel.text = comicDescription
		}
		else {
			self.comicDescriptionLabel.text = "No description."
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
		self.tableView.register(DetailsTableViewCell.self,
								forCellReuseIdentifier: DetailsTableViewCell.cellReuseIdentifier)
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

	func setupImageViewAuthorsNotFound() {
		self.view.addSubview(self.imageViewAuthorsNotFound)
		self.imageViewAuthorsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.imageViewAuthorsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.imageViewAuthorsNotFound.centerYAnchor.constraint(equalTo: self.tableView.centerYAnchor),
			self.imageViewAuthorsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewComicsNotFound),
			self.imageViewAuthorsNotFound.heightAnchor.constraint(equalToConstant: Size.imageViewComicsNotFound),
			])
		self.imageViewAuthorsNotFound.image = UIImage(named: "no_authors")
		self.imageViewAuthorsNotFound.isHidden = true
	}

	func setupLabelAuthorsNotFound() {
		self.view.addSubview(self.labelAuthorsNotFound)
		self.labelAuthorsNotFound.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.labelAuthorsNotFound.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor),
			self.labelAuthorsNotFound.topAnchor.constraint(equalTo: self.imageViewAuthorsNotFound.bottomAnchor,
														  constant: Insets.topInsetLabelComicsNotFound),
			self.labelAuthorsNotFound.widthAnchor.constraint(equalToConstant: Size.imageViewComicsNotFound),
			])
		self.labelAuthorsNotFound.text = "Authors not found"
		self.labelAuthorsNotFound.numberOfLines = 0
		self.labelAuthorsNotFound.textAlignment = .center
		self.labelAuthorsNotFound.font = Fonts.helvetica18
		self.labelAuthorsNotFound.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		self.labelAuthorsNotFound.isHidden = true
	}
}

extension ComicDetailsViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
		return TableViewConstants.tableViewCellHeight
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		let selectedCell = self.tableView.cellForRow(at: indexPath) as? DetailsTableViewCell
		selectedCell?.customNameLabel.textColor = .white
		selectedCell?.backgroundColor = #colorLiteral(red: 0.846742928, green: 0.1176741496, blue: 0, alpha: 1)
		guard let author = self.comicDetailsPresenter.getAuthor(at: indexPath.row) else { return }
		self.comicDetailsPresenter.pressOnCell(withAuthor: author)
	}

	func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? DetailsTableViewCell
		highlightedCell?.customNameLabel.textColor = .white
		highlightedCell?.backgroundColor = #colorLiteral(red: 1, green: 0.3005838394, blue: 0.2565174997, alpha: 1)
	}

	func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
		let highlightedCell = self.tableView.cellForRow(at: indexPath) as? DetailsTableViewCell
		highlightedCell?.customNameLabel.textColor = .black
		highlightedCell?.backgroundColor = .white
	}
}

extension ComicDetailsViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.comicDetailsPresenter.getAuthorsCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = self.tableView.dequeueReusableCell(withIdentifier: DetailsTableViewCell.cellReuseIdentifier)
			as? DetailsTableViewCell

		cell?.customNameLabel.text = self.comicDetailsPresenter.getAuthorName(at: indexPath.row)
		if let data = self.comicDetailsPresenter.getAuthorImage(at: indexPath.row) {
			cell?.customImageView.image = UIImage(data: data)
		}

		return cell ?? UITableViewCell(style: .default, reuseIdentifier: DetailsTableViewCell.cellReuseIdentifier)
	}
}
extension ComicDetailsViewController: IComicDetailsView
{
	func showData(withImageData data: Data?, withAuthorsCount count: Int) {
		self.comicTitleLabel.isHidden = false
		self.comicDescriptionLabel.isHidden = false
		if count == 0 {
			self.imageViewAuthorsNotFound.isHidden = false
			self.labelAuthorsNotFound.isHidden = false
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
