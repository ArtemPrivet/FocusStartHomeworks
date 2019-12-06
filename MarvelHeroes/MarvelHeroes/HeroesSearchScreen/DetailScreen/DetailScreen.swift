//
//  DetailScreen.swift
//  MarvelHeroes
//
//  Created by Антон on 05.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import UIKit

final class DetailScreenViewController: UIViewController
{
	private var detailPresenter: DetailScreenPresenter

	init(detailPresenter: DetailScreenPresenter) {
		self.detailPresenter = detailPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available (*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private let tableView = UITableView()

	private func setupTableView() {
		self.view.addSubview(tableView)
		if #available(iOS 11.0, *) {
			self.tableView.insetsContentViewsToSafeArea = false
			self.tableView.insetsLayoutMarginsFromSafeArea = false
		}
		if #available(iOS 11.0, *) {
			self.tableView.contentInsetAdjustmentBehavior = .never
		}
		else {
			automaticallyAdjustsScrollViewInsets = false
		}
		let screenSize = UIScreen.main.bounds.size
		self.tableView.frame = CGRect(origin: .zero, size: screenSize)
		self.tableView.tableHeaderView = imageView
		self.tableView.tableFooterView = UIView()
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 44
		self.tableView.reloadData()
	}

	private let imageView = UIImageView()

	private func setupImageView() {
		let screenSize = UIScreen.main.bounds
		let screenWidth = screenSize.size.width
		let screenHeight = screenSize.size.height
		imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 1.8)
		self.imageView.backgroundColor = .blue
		self.imageView.layoutSubviews()
		if let imageData = detailPresenter.imageData {
			self.imageView.image = UIImage(data: imageData)
			self.imageView.clipsToBounds = true
			self.imageView.contentMode = .scaleToFill
			self.imageView.layoutSubviews()
		}
	}

	private let nameLabel = UILabel()

	private func setupNameLabel() {
		self.imageView.addSubview(nameLabel)
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
		nameLabel.text = detailPresenter.name
		nameLabel.textColor = .black
		nameLabel.numberOfLines = 0
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 100),
			nameLabel.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 15),
			nameLabel.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -15),
		])
	}

	private let descriptionLabel = UILabel()

	private func setupDescriptionLabel() {
		self.imageView.addSubview(descriptionLabel)
		self.descriptionLabel.numberOfLines = 0
		self.descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
		self.descriptionLabel.text = detailPresenter.description
		self.descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		self.descriptionLabel.adjustsFontSizeToFitWidth = true
		self.descriptionLabel.minimumScaleFactor = 0.1
		NSLayoutConstraint.activate([
			self.descriptionLabel.topAnchor.constraint(equalTo: self.nameLabel.bottomAnchor, constant: 20),
			self.descriptionLabel.leadingAnchor.constraint(equalTo: self.nameLabel.leadingAnchor),
			self.descriptionLabel.trailingAnchor.constraint(equalTo: self.nameLabel.trailingAnchor),
			self.descriptionLabel.bottomAnchor.constraint(equalTo: self.imageView.bottomAnchor, constant: -10),
		])
	}

	let activityIndicator = UIActivityIndicatorView()

	override func viewDidLoad() {
		super.viewDidLoad()
		detailPresenter.attachView(detailScreenViewController: self)
		self.tableView.dataSource = self
		self.tableView.delegate = self
		self.view.backgroundColor = .white
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
		self.navigationController?.view.backgroundColor = .clear
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		detailPresenter.getComicsAtHeroID()
		setupTableView()
		setupImageView()
		setupNameLabel()
		setupDescriptionLabel()
		imageView.addGradientLayerInBackground(colors: [UIColor.white.withAlphaComponent(0.8), .white])
	}
}
// MARK: - UTTableViewDataSource, UTTableViewDelegate
extension DetailScreenViewController: UITableViewDataSource, UITableViewDelegate
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return detailPresenter.comicsCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		cell.textLabel?.text = detailPresenter.getComics(at: indexPath).title
		cell.detailTextLabel?.text = detailPresenter.getComics(at: indexPath).description
		cell.imageView?.clipsToBounds = true
		detailPresenter.getComicsImageData(indexPath: indexPath) { data in
			DispatchQueue.main.async {
				let image = UIImage(data: data)
				cell.imageView?.image = image
				cell.imageView?.image = cell.imageView?.image?.imageWithImage(scaledToSize: CGSize(width: 60, height: 60))
				cell.layoutSubviews()
			}
		}
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.tableView.deselectRow(at: indexPath, animated: true)
	}
}
// MARK: - IDetailScreenData
extension DetailScreenViewController: IDetailScreenData
{
	func startLoading() {
		self.tableView.isHidden = true
		self.view.addSubview(activityIndicator)
		activityIndicator.frame = self.view.bounds
		let transform = CGAffineTransform(scaleX: 2.5, y: 2.5)
		activityIndicator.color = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
		activityIndicator.transform = transform
		activityIndicator.startAnimating()
	}

	func finishLoading() {
		self.activityIndicator.stopAnimating()
		self.activityIndicator.removeFromSuperview()
		self.tableView.reloadData()
		self.tableView.isHidden = false
	}

	func setEmptyComics() {
		//завтра постараюсь запилить :(
		return
	}
}
