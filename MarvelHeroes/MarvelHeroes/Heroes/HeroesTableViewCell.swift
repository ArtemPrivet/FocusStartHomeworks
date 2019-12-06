//
//  HeroesTableViewCell.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class HeroesTableViewCell: UITableViewCell
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
		self.heroeImageView.clipsToBounds = true
		self.heroeImageView.layer.cornerRadius = self.heroeImageView.bounds.width / 2
	}

	let heroeNameLabel = UILabel()
	let heroeDescriptionLabel = UILabel()
	let heroeImageView = UIImageView()

	func settingsForImageView() {
		self.addSubview(self.heroeImageView)
		self.heroeImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.heroeImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
															 constant: TableViewConstants.tableViewCellLeftInset),
			self.heroeImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.heroeImageView.heightAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageSize),
			self.heroeImageView.widthAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageSize),
			])
		self.heroeImageView.contentMode = .scaleAspectFill
	}

	func settingsForNameLabel() {
		self.addSubview(self.heroeNameLabel)
		self.heroeNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.heroeNameLabel.leadingAnchor.constraint(equalTo: self.heroeImageView.trailingAnchor,
															 constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.heroeNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
															  constant: TableViewConstants.tableViewCellRightInset),
			self.heroeNameLabel.topAnchor.constraint(equalTo: self.heroeImageView.topAnchor),
		])
		self.heroeNameLabel.font = UIFont(name: "Helvetica", size: 20)
	}

	func settingsForDescriptionLabel() {
		self.addSubview(self.heroeDescriptionLabel)
		self.heroeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.heroeDescriptionLabel.leadingAnchor.constraint(equalTo: self.heroeImageView.trailingAnchor,
															 constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.heroeDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
															  constant: TableViewConstants.tableViewCellRightInset),
			self.heroeDescriptionLabel.bottomAnchor.constraint(equalTo: self.heroeImageView.bottomAnchor),
			])
		self.heroeDescriptionLabel.font = UIFont(name: "Helvetica", size: 16)
		self.heroeDescriptionLabel.textColor = .lightGray
	}
}
