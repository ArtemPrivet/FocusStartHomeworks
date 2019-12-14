//
//  HeroesTableViewCell.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class CustomTableViewCell: UITableViewCell
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
		self.customImageView.layer.cornerRadius = self.customImageView.bounds.width / 2
	}

	static let cellReuseIdentifier = "cell"
	let customNameLabel = UILabel()
	let customDescriptionLabel = UILabel()
	let customImageView = UIImageView()
}

private extension CustomTableViewCell
{
	func settingsForImageView() {
		self.addSubview(self.customImageView)
		self.customImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.customImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
														 constant: TableViewConstants.tableViewCellLeftInset),
			self.customImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.customImageView.heightAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageSize),
			self.customImageView.widthAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageSize),
			])
		self.customImageView.contentMode = .scaleAspectFill
		self.customImageView.clipsToBounds = true
	}

	func settingsForNameLabel() {
		self.addSubview(self.customNameLabel)
		self.customNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.customNameLabel.leadingAnchor.constraint(equalTo: self.customImageView.trailingAnchor,
														 constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.customNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
														  constant: TableViewConstants.tableViewCellRightInset),
			self.customNameLabel.topAnchor.constraint(equalTo: self.customImageView.topAnchor),
			])
		self.customNameLabel.font = Fonts.helvetica20
	}

	func settingsForDescriptionLabel() {
		self.addSubview(self.customDescriptionLabel)
		self.customDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.customDescriptionLabel.leadingAnchor.constraint(equalTo: self.customImageView.trailingAnchor,
																constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.customDescriptionLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
																 constant: TableViewConstants.tableViewCellRightInset),
			self.customDescriptionLabel.bottomAnchor.constraint(equalTo: self.customImageView.bottomAnchor),
			])
		self.customDescriptionLabel.font = Fonts.helvetica16
		self.customDescriptionLabel.textColor = .lightGray
	}
}
