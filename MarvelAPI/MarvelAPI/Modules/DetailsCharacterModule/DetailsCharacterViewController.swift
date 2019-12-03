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
	var descriptionLabel = UILabel()
	var comicsTableView = UITableView()
	
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
		self.navigationController?.navigationBar.backgroundColor = .green

	}
	private func setupViews() {
		self.view.addSubview(titleLabel)
		self.view.addSubview(descriptionLabel)
		self.view.addSubview(comicsTableView)

		let selectedCharacter = presenter.getCharacter()
		
		titleLabel.text = selectedCharacter.name
		titleLabel.numberOfLines = 0
		titleLabel.font = UIFont.boldSystemFont(ofSize: 34.0)

		descriptionLabel.text = selectedCharacter.description == "" ? "No info" : selectedCharacter.description
		descriptionLabel.numberOfLines = 0
		descriptionLabel.textAlignment = .justified
		descriptionLabel.backgroundColor = .green
		
		self.view.backgroundColor = .yellow
	}
	
	private func setupConstraints() {
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		comicsTableView.translatesAutoresizingMaskIntoConstraints = false
		
		
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			titleLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			
			descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
			descriptionLabel.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			descriptionLabel.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
			
			comicsTableView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
			comicsTableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
			comicsTableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
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
		cell.textLabel?.text = presenter.getComics(index: indexPath.row).title
		cell.imageView?.image = presenter.getComicsImage(index: indexPath.row)
		return cell
	}
	
	
}
