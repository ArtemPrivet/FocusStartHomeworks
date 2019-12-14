//
//  TestDetailViewController.swift
//  MarvelHeroes
//
//  Created by Антон on 07.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import UIKit
protocol IDetailViewController
{
	func startLoading()
	func finishLoading()
}

final class DetailViewController: UIViewController
{
	private let detailPresenter: DetailPresenter
	private let tableView = UITableView()
	private let imageView = UIImageView()
	private let nameLabel = UILabel()
	private let containerView = UIView()
	private let loadingView = UIView()
	private let activityIndicator = UIActivityIndicatorView()
	private let descriptionLabel = UILabel()

	init(detailPresenter: DetailPresenter) {
		self.detailPresenter = detailPresenter
		super.init(nibName: nil, bundle: nil)
	}

	@available (*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.detailPresenter.attachViewController(viewController: self)
		self.view.backgroundColor = .white
		//setupNavigationBarToDetailScreen()
		setupImageView()
		setupNameLabel()
		setupTableView()
		setupDescriptionLabel()
		detailPresenter.getDataForTableView()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupNavigationBarToDetailScreen()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		setupNavigationBarToMainScreen()
	}

	private func setupNavigationBarToDetailScreen() {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationController?.navigationBar.isTranslucent = true
	}

	private func setupNavigationBarToMainScreen() {
		self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
		self.navigationController?.navigationBar.shadowImage = nil
		self.navigationController?.view.backgroundColor = .white
		self.navigationController?.navigationBar.isTranslucent = false
	}

	private func setupTableView() {
		self.view.addSubview(tableView)
		var height: CGFloat = 0
		if let tabBarHeight = self.tabBarController?.tabBar.frame.height {
			height = tabBarHeight
		}
		if #available(iOS 11.0, *) {
			self.tableView.insetsContentViewsToSafeArea = false
			self.tableView.insetsLayoutMarginsFromSafeArea = false
			self.tableView.contentInsetAdjustmentBehavior = .never
		}
		else {
			automaticallyAdjustsScrollViewInsets = false
		}
		self.tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
			self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -height),
		])
		self.tableView.tableHeaderView = imageView
		self.tableView.tableFooterView = UIView()
		self.tableView.rowHeight = UITableView.automaticDimension
		self.tableView.estimatedRowHeight = 44
		self.tableView.delegate = self
		self.tableView.dataSource = self
	}

	private func setupImageView() {
		let screenSize = UIScreen.main.bounds
		let screenWidth = screenSize.size.width
		let screenHeight = screenSize.size.height
		imageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight / 1.8)
		imageView.addGradientLayerInForeground(colors: [UIColor.white.withAlphaComponent(0.6), .white])
		self.imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.imageView.heightAnchor.constraint(equalToConstant: screenHeight / 1.8),
			self.imageView.widthAnchor.constraint(equalToConstant: screenWidth),
		])
		self.imageView.backgroundColor = .blue
		if let imageData = detailPresenter.imageData {
			self.imageView.image = UIImage(data: imageData)
			self.imageView.clipsToBounds = true
			self.imageView.contentMode = .scaleAspectFill
		}
	}

	private func setupNameLabel() {
		self.imageView.addSubview(nameLabel)
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
		nameLabel.text = detailPresenter.getNameOrTitleLabelText
		nameLabel.textColor = .black
		nameLabel.numberOfLines = 0
		NSLayoutConstraint.activate([
			nameLabel.topAnchor.constraint(equalTo: self.imageView.topAnchor, constant: 100),
			nameLabel.leadingAnchor.constraint(equalTo: self.imageView.leadingAnchor, constant: 15),
			nameLabel.trailingAnchor.constraint(equalTo: self.imageView.trailingAnchor, constant: -15),
		])
	}

	private func setupDescriptionLabel() {
		self.imageView.addSubview(descriptionLabel)
		self.descriptionLabel.numberOfLines = 0
		self.descriptionLabel.font = UIFont.systemFont(ofSize: 20, weight: .regular)
		self.descriptionLabel.text = detailPresenter.getDescriptionLabelText
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
}
// MARK: - UTTableViewDataSource, UTTableViewDelegate
extension DetailViewController: UITableViewDataSource, UITableViewDelegate
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return detailPresenter.numberOfRows
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
		cell.textLabel?.text = detailPresenter.getTextForCell(at: indexPath)
		cell.detailTextLabel?.text = detailPresenter.getDetailTextForCell(at: indexPath)
		cell.imageView?.clipsToBounds = true
		detailPresenter.getImageDataForCell(at: indexPath, callBack: { data in
			cell.imageView?.image = UIImage(data: data)
			cell.layoutSubviews()
			guard let height = cell.imageView?.bounds.size.height else { return }
			cell.imageView?.image = cell.imageView?.image?.imageWithImage(scaledToSize: CGSize(width: height, height: height))
		})
		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		self.detailPresenter.tapToRow(at: indexPath)
		self.tableView.deselectRow(at: indexPath, animated: true)
	}
}
extension DetailViewController: IDetailViewController
{
	func startLoading() {
		self.tableView.isHidden = true
		self.view.showActivityIndicatory(containerAcitivtyIndicator: containerView,
										 loadingView: loadingView,
										 activityIndicator: activityIndicator)
	}

	func finishLoading() {
		self.activityIndicator.stopAnimating()
		self.containerView.removeFromSuperview()
		self.tableView.reloadData()
		self.tableView.isHidden = false
	}
}
