//
//  ComicsTableViewCell.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class ComicsTableViewCell: UITableViewCell
{
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .disclosureIndicator
		self.selectionStyle = .none
		self.settingsForImageView()
		self.settingsForNameLabel()
		self.settingsForDescriptionLabel()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.comicImageView.clipsToBounds = true
		self.comicImageView.layer.cornerRadius = self.comicImageView.bounds.width / 2
	}

	let comicNameLabel = UILabel()
	let comicDescriptionLabel = UILabel()
	let comicImageView = UIImageView()

	func settingsForImageView() {
		self.addSubview(self.comicImageView)
		self.comicImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.comicImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
														 constant: TableViewConstants.tableViewCellLeftInset),
			self.comicImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.comicImageView.heightAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageSize),
			self.comicImageView.widthAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageSize),
			])
		self.comicImageView.contentMode = .scaleAspectFill
	}

	func settingsForNameLabel() {
		self.addSubview(self.comicNameLabel)
		self.comicNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.comicNameLabel.leadingAnchor.constraint(equalTo: self.comicImageView.trailingAnchor,
														 constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.comicNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
														  constant: TableViewConstants.tableViewCellRightInset),
			self.comicNameLabel.topAnchor.constraint(equalTo: self.comicImageView.topAnchor),
			])
		self.comicNameLabel.font = UIFont(name: "Helvetica", size: 20)
	}

	func settingsForDescriptionLabel() {
		self.addSubview(self.comicDescriptionLabel)
		self.comicDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.comicDescriptionLabel.leadingAnchor.constraint(equalTo: self.comicImageView.trailingAnchor,
																constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.comicDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
																 constant: TableViewConstants.tableViewCellRightInset),
			self.comicDescriptionLabel.bottomAnchor.constraint(equalTo: self.comicImageView.bottomAnchor),
			])
		self.comicDescriptionLabel.font = UIFont(name: "Helvetica", size: 16)
		self.comicDescriptionLabel.textColor = .lightGray
	}
}
