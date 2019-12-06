//
//  AuthorDetailsTableViewCell.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 06/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class AuthorDetailsTableViewCell: UITableViewCell
{
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .disclosureIndicator
		self.selectionStyle = .none
		self.settingsForImageView()
		self.settingsForTitleLabel()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	let comicTitleLabel = UILabel()
	let comicImageView = UIImageView()

	func settingsForImageView() {
		self.addSubview(self.comicImageView)
		self.comicImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.comicImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
														 constant: TableViewConstants.tableViewCellLeftInset),
			self.comicImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.comicImageView.heightAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageHeight),
			self.comicImageView.widthAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageWidth),
			])
		self.comicImageView.clipsToBounds = true
		self.comicImageView.contentMode = .scaleAspectFit
	}

	func settingsForTitleLabel() {
		self.addSubview(self.comicTitleLabel)
		self.comicTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.comicTitleLabel.leadingAnchor.constraint(equalTo: self.comicImageView.trailingAnchor,
														  constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.comicTitleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
														   constant: TableViewConstants.tableViewCellRightInset),
			self.comicTitleLabel.centerYAnchor.constraint(equalTo: self.comicImageView.centerYAnchor),
			])
		self.comicTitleLabel.font = UIFont(name: "Helvetica", size: 20)
	}
}
