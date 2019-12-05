//
//  DetailsComicsViewController.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

import UIKit

protocol IDetailsComicsViewController: class {
	func updateData()
}

class DetailsComicsViewController: UIViewController {
	
	var titleLabel = UILabel()
	var descriptionLabel = UITextView()
	var charactersTableView = UITableView()
	var backgroundImageView = ImageViewWithGradient(frame: .zero)
	var activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

	var presenter: IDetailsComicsPresenter
	
	init(presenter: IDetailsComicsPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		charactersTableView.dataSource = self
		charactersTableView.delegate = self
		
		setupViews()
		setupConstraints()
		setupNavigationBar()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("DetailsComicsViewController deinit")
	}
	
	private func setupNavigationBar() {
		self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		self.navigationController?.navigationBar.shadowImage = UIImage()
		self.navigationItem.largeTitleDisplayMode = .never
	}
	
	private func setupViews() {
		self.view.addSubview(backgroundImageView)
		self.view.addSubview(titleLabel)
		self.view.addSubview(descriptionLabel)
		self.view.addSubview(charactersTableView)
		self.charactersTableView.addSubview(activityIndicator)
		self.activityIndicator.color = .black
		self.charactersTableView.tableFooterView = UIView()
		self.activityIndicator.startAnimating()

		backgroundImageView.contentMode = .scaleAspectFill
		
		
		let selectedComics = presenter.getComics()
		
		titleLabel.text = selectedComics.title
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
		
		descriptionLabel.text = selectedComics.description == "" || selectedComics.description == nil ? "No info" : selectedComics.description
		descriptionLabel.backgroundColor = .red
		descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
		descriptionLabel.textAlignment = .justified
		descriptionLabel.backgroundColor = UIColor.white.withAlphaComponent(0.0)
	}
	
	private func setupConstraints() {
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		charactersTableView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false
		
		NSLayoutConstraint.activate([
			backgroundImageView.topAnchor.constraint(equalTo: self.view.topAnchor),
			backgroundImageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			backgroundImageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			backgroundImageView.heightAnchor.constraint(equalTo: self.view.heightAnchor,multiplier: 1 / 2),
			
			titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			descriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			descriptionLabel.bottomAnchor.constraint(equalTo: charactersTableView.topAnchor, constant: -8),
			
			charactersTableView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
			charactersTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			charactersTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			charactersTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			
			activityIndicator.centerXAnchor.constraint(equalTo: self.charactersTableView.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: self.charactersTableView.centerYAnchor),
			])
	}
}

extension DetailsComicsViewController: IDetailsComicsViewController {
	func updateData() {
		self.charactersTableView.reloadData()
	}
}

extension DetailsComicsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getCharactersCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = charactersTableView.dequeueReusableCell(withIdentifier: "characterCell") ?? UITableViewCell(style: .default, reuseIdentifier: "characterCell")
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = presenter.getCharacter(index: indexPath.row).name
		presenter.getCharacterImage(index: indexPath.row)
		return cell
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
