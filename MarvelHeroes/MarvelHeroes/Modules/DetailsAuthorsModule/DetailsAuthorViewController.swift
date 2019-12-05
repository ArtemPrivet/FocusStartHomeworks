//
//  DetailsAuthorViewController.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IDetailsAuthorViewController: class {
	func updateData()
}

class DetailsAuthorViewController: UIViewController {
	
	var titleLabel = UILabel()
	var lastNameLabel = UITextView()
	var comicsesTableView = UITableView()
	var backgroundImageView = ImageViewWithGradient(frame: .zero)
	var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
	
	var presenter: IDetailsAuthorPresenter
	
	init(presenter: IDetailsAuthorPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		comicsesTableView.dataSource = self
		comicsesTableView.delegate = self
		
		setupViews()
		setupConstraints()
		setupNavigationBar()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("DetailsAuthorViewController deinit")
	}
	
	private func setupNavigationBar() {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationItem.largeTitleDisplayMode = .never
	}
	
	private func setupViews() {
		self.view.addSubview(backgroundImageView)
		self.view.addSubview(titleLabel)
		self.view.addSubview(lastNameLabel)
		self.view.addSubview(comicsesTableView)
		self.comicsesTableView.addSubview(activityIndicator)
		self.activityIndicator.color = .black
		self.comicsesTableView.tableFooterView = UIView()
		self.activityIndicator.startAnimating()
		
		backgroundImageView.contentMode = .scaleAspectFill
		
		
		let selectedAuthor = presenter.getAuthor()
		
		titleLabel.text = selectedAuthor.firstName
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
		
		lastNameLabel.text = selectedAuthor.lastName == "" ? "No info" : selectedAuthor.lastName
		lastNameLabel.backgroundColor = .red
		lastNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
		lastNameLabel.textAlignment = .justified
		lastNameLabel.backgroundColor = UIColor.white.withAlphaComponent(0.0)
	}
	
	private func setupConstraints() {
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
		comicsesTableView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			backgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor,multiplier: 1 / 2),
			
			titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			
			lastNameLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			lastNameLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			lastNameLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			lastNameLabel.bottomAnchor.constraint(equalTo: comicsesTableView.topAnchor, constant: -8),
			
			comicsesTableView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
			comicsesTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			comicsesTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			comicsesTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.comicsesTableView.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.comicsesTableView.centerYAnchor),
			])
	}
}

extension DetailsAuthorViewController: IDetailsAuthorViewController {
	func updateData() {
		self.comicsesTableView.reloadData()
	}
}

extension DetailsAuthorViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getComicsesCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = comicsesTableView.dequeueReusableCell(withIdentifier: "comicsCell") ?? UITableViewCell(style: .default, reuseIdentifier: "comicsCell")
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = presenter.getComics(index: indexPath.row).title
		presenter.getComicsImage(index: indexPath.row)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
