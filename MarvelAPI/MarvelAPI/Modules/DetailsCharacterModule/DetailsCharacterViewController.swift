//
//  DetailsCharacterViewController.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IDetailsCharacterViewController: class {
	func updateData()
}

class DetailsCharacterViewController: UIViewController {
	
	var titleLabel = UILabel()
	var descriptionLabel = UITextView()
	var comicsTableView = UITableView()
	var backgroundImageView = ImageViewWithGradient(frame: .zero)
	
	var presenter: IDetailsCharacterPresenter
	
	init(presenter: IDetailsCharacterPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = .white
		comicsTableView.dataSource = self
		comicsTableView.delegate = self
		
		setupViews()
		setupConstraints()
		setupNavigationBar()
	}
	
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		print("DetailsViewController deinit")
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
		self.view.addSubview(comicsTableView)
		print(backgroundImageView.bounds)
		
		backgroundImageView.contentMode = .scaleAspectFill
		
		
		let selectedCharacter = presenter.getCharacter()
		
		titleLabel.text = selectedCharacter.name
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)
		
		descriptionLabel.text = selectedCharacter.description == "" ? "No info" : selectedCharacter.description
//		descriptionLabel.numberOfLines = 0
		descriptionLabel.backgroundColor = .red
		descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14)
		descriptionLabel.textAlignment = .justified
		descriptionLabel.backgroundColor = UIColor.white.withAlphaComponent(0.0)
	}
	
	private func setupConstraints() {
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		comicsTableView.translatesAutoresizingMaskIntoConstraints = false
		
		
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
			descriptionLabel.bottomAnchor.constraint(equalTo: comicsTableView.topAnchor, constant: -8),

			comicsTableView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor),
			comicsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
			comicsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
			comicsTableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
			])
	}
}

extension DetailsCharacterViewController: IDetailsCharacterViewController {
	func updateData() {
		self.comicsTableView.reloadData()
	}
}

extension DetailsCharacterViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getComicsCount()
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = comicsTableView.dequeueReusableCell(withIdentifier: "comicsCell") ?? UITableViewCell(style: .default, reuseIdentifier: "comicsCell")
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
