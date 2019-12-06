//
//  CharacterInfoViewController.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 05.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit
import SnapKit

final class CharacterInfoViewController: UIViewController
{
	let characterImage = UIImageView()
	let comicsTableView = UITableView()
	let characterDescriptionTextView = UITextView()
	let gradient = CAGradientLayer()
	private let loadIndicator = UIActivityIndicatorView(style: .gray)
	var presenter: ICharacterInfoPresenter?

	override func viewDidLoad() {
		super.viewDidLoad()
		comicsTableView.dataSource = self
		addSubviews()
		configureViews()
		makeConstraints()
	}
	private func addSubviews() {
		view.addSubview(characterImage)
		view.addSubview(comicsTableView)
		view.addSubview(characterDescriptionTextView)
	}
	override func viewDidLayoutSubviews() {
		gradient.frame = characterImage.bounds
	}
	private func configureViews() {
		view.backgroundColor = UIColor.white
		characterDescriptionTextView.backgroundColor = .none
		let character = presenter?.getCharacter()
		presenter?.getImage()
		characterDescriptionTextView.font = .systemFont(ofSize: 21)
		title = character?.name
		characterDescriptionTextView.isEditable = false
		characterDescriptionTextView.text = character?.description
		comicsTableView.backgroundView = loadIndicator
		comicsTableView.tableFooterView = UIView()
		comicsTableView.register(ComicsTableViewCell.self, forCellReuseIdentifier: "cell")
		setGradient()
	}
	private func setGradient() {
		let startColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5).cgColor
		let endColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
		gradient.colors = [startColor, endColor]
		characterImage.layer.insertSublayer(gradient, at: 0)
	}
	private func makeConstraints() {
		characterImage.snp.makeConstraints { maker in
			maker.leading.equalToSuperview()
			maker.top.equalToSuperview()
			maker.trailing.equalToSuperview()
			maker.bottom.equalToSuperview().dividedBy(2)
		}
		comicsTableView.snp.makeConstraints { maker in
			maker.top.equalTo(characterImage.snp.bottom)
			maker.leading.trailing.bottom.equalToSuperview()
		}
		characterDescriptionTextView.snp.makeConstraints { maker in
			maker.leading.equalToSuperview().offset(8)
			maker.trailing.equalToSuperview().offset(-8)
			maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
			maker.bottom.equalTo(characterImage.snp.bottom)
		}
	}
	func showLoadingIndicator() {
		self.loadIndicator.startAnimating()
	}
	func hideLoadingIndicator() {
		self.loadIndicator.stopAnimating()
	}
}
extension CharacterInfoViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter?.getComicsCount() ?? 0
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ComicsTableViewCell
		else { return UITableViewCell() }

		let comics = presenter?.getComics(by: indexPath.row)
		cell.nameLabel.text = comics?.title
		if let image = comics?.thumbnail {
			presenter?.getComicsImage(for: image, by: indexPath)
		}
		return cell
	}
}
