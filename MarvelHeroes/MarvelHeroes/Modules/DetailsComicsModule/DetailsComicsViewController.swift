//
//  DetailsComicsViewController.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

final class DetailsComicsViewController: DetailsViewController
{
	var presenter: IDetailsComicsPresenter

	init(presenter: IDetailsComicsPresenter) {
		self.presenter = presenter
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		descriptionLabel.text = presenter.getComics().description
		titleLabel.text = presenter.getComics().title
	}
}

extension DetailsComicsViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getCharactersCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
			UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = presenter.getCharacter(index: indexPath.row).name
		presenter.getCharacterImage(index: indexPath.row)
		return cell
	}
}

extension DetailsComicsViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
//		presenter.showDetailAuthor(index: indexPath.row)
	}
}
