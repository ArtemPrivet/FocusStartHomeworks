//
//  DetailsAuthorViewController.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

final class DetailsAuthorViewController: DetailsViewController
{
	var presenter: IDetailsAuthorPresenter

	init(presenter: IDetailsAuthorPresenter) {
		self.presenter = presenter
		super.init()
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.dataSource = self
		tableView.delegate = self
		descriptionLabel.text = presenter.getAuthor().firstName
		titleLabel.text = presenter.getAuthor().lastName
	}
}

extension DetailsAuthorViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return presenter.getComicsesCount()
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) ??
			UITableViewCell(style: .default, reuseIdentifier: reuseIdentifier)
		cell.imageView?.image = #imageLiteral(resourceName: "standard_medium_wait_image")
		cell.accessoryType = .disclosureIndicator
		cell.textLabel?.text = presenter.getComics(index: indexPath.row).title
		presenter.getComicsImage(index: indexPath.row)
		return cell
	}
}

extension DetailsAuthorViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
