//
//  DetailsViewController.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 08.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//
import UIKit

protocol IDetailsViewController: AnyObject
{
	func updateData()
	func stopActivityIndicator()
	func setBackgroundImageView(image: UIImage)
	func updateTableViewCell(index: Int, image: UIImage)
	func showAlert(error: Error)
}
// swiftlint:disable:next required_final
class DetailsViewController: UIViewController
{
	let reuseIdentifier = "cell"
	var tableView = UITableView()
	var descriptionLabel = UITextView()
	var titleLabel = UILabel()

	private var backgroundImageView = ImageViewWithGradient(frame: .zero)
	private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

	override func viewDidLoad() {
		super.viewDidLoad()
		view.backgroundColor = .white
		activityIndicator.startAnimating()
		setupViews()
		setupConstraints()
		setupNavigationBar()
	}

	init() {
		super.init(nibName: nil, bundle: nil)
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func setupNavigationBar() {
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationItem.largeTitleDisplayMode = .never
	}

	private func setupViews() {
		view.addSubview(backgroundImageView)
		view.addSubview(titleLabel)
		view.addSubview(descriptionLabel)
		view.addSubview(tableView)
		tableView.addSubview(activityIndicator)
		activityIndicator.color = .black
		tableView.tableFooterView = UIView()
		activityIndicator.startAnimating()
		backgroundImageView.contentMode = .scaleAspectFill
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)

		descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
		descriptionLabel.textAlignment = .justified
		descriptionLabel.backgroundColor = UIColor.white.withAlphaComponent(0.0)
	}

	private func setupConstraints() {
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			backgroundImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1 / 2),

			titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),

			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			descriptionLabel.bottomAnchor.constraint(equalTo: tableView.topAnchor, constant: -8),

			tableView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
			tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),

			activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
			])
	}
}

extension DetailsViewController: IDetailsViewController
{
	func showAlert(error: Error) {
		let alert = UIAlertController(title: "Load error",
									  message: error.localizedDescription,
									  preferredStyle: UIAlertController.Style.alert)
		alert.addAction(UIAlertAction(title: "OK",
									  style: UIAlertAction.Style.default))
		self.present(alert, animated: true, completion: nil)
	}

	func updateData() {
		tableView.reloadData()
	}

	func stopActivityIndicator() {
		activityIndicator.stopAnimating()
	}

	func setBackgroundImageView(image: UIImage) {
		backgroundImageView.image = image
	}

	func updateTableViewCell(index: Int, image: UIImage) {
		guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
		cell.imageView?.image = image
		cell.layoutSubviews()
	}
}
