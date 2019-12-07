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
	private let characterImage = UIImageView()
	private let comicsTableView = UITableView()
	private let characterDescriptionTextView = UITextView()
	private let gradient = CAGradientLayer()
	private let cdllId = "cell"
	private var gradientColor: UIColor = {
		if #available(iOS 13, *) {
			return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
				if UITraitCollection.userInterfaceStyle == .dark {
					return UIColor.black
				}
				else {
					return UIColor.white
				}
			}
		}
		else {
			return UIColor.white
		}
	}()
	private let loadIndicator = UIActivityIndicatorView(style: .whiteLarge)
	private let presenter: ICharacterInfoPresenter

	init(presenter: CharacterInfoPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
	}
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func viewDidLoad() {
		super.viewDidLoad()
		presenter.loadComics()
		comicsTableView.dataSource = self
		addSubviews()
		configureViews()
		makeConstraints()
	}
	override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
		super.traitCollectionDidChange(previousTraitCollection)
		setGradient()
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
		let character = presenter.getCharacter()
		presenter.loadCharacterImage()
		characterDescriptionTextView.font = .systemFont(ofSize: 21)
		title = character.name
		characterDescriptionTextView.isEditable = false
		characterDescriptionTextView.text = character.description
		comicsTableView.backgroundView = loadIndicator
		comicsTableView.tableFooterView = UIView()
		comicsTableView.register(ComicsTableViewCell.self, forCellReuseIdentifier: cdllId)
		setGradient()
	}
	private func setGradient() {
		let startColor = gradientColor.withAlphaComponent(0.5).cgColor
		let endColor = gradientColor.withAlphaComponent(1).cgColor
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
	func setComicsImage(image: UIImage, for index: Int) {
		guard let cell = comicsTableView.cellForRow(at: IndexPath(row: index, section: 0))
			as? ComicsTableViewCell else { return }
		cell.set(comicCover: image)
		cell.layoutSubviews()
	}
	func setCharacterImage(image: UIImage) {
		characterImage.image = image
	}
	func updateComicsTableView() {
		comicsTableView.reloadData()
	}
}
extension CharacterInfoViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.comicsCount
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: cdllId, for: indexPath) as? ComicsTableViewCell
		else { return UITableViewCell() }

		let comics = presenter.getComics(by: indexPath.row)
		cell.set(text: comics?.title)
		if let image = comics?.thumbnail {
			presenter.getComicsImage(for: image, by: indexPath.row)
		}
		return cell
	}
}
