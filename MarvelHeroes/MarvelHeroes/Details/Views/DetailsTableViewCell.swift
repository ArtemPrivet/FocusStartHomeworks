//
//  DetailsTableViewCell.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 14/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class DetailsTableViewCell: UITableViewCell
{
	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		self.accessoryType = .disclosureIndicator
		self.selectionStyle = .none
		self.settingsForImageView()
		self.settingsForNameLabel()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	static let cellReuseIdentifier = "cell"
	let customNameLabel = UILabel()
	let customImageView = UIImageView()
}

private extension DetailsTableViewCell
{
	func settingsForImageView() {
	self.addSubview(self.customImageView)
	self.customImageView.translatesAutoresizingMaskIntoConstraints = false
	NSLayoutConstraint.activate([
		self.customImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
													  constant: TableViewConstants.tableViewCellLeftInset),
		self.customImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
		self.customImageView.heightAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageHeight),
		self.customImageView.widthAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageWidth),
		])
	self.customImageView.clipsToBounds = true
	self.customImageView.contentMode = .scaleAspectFit
	}

	func settingsForNameLabel() {
		self.addSubview(self.customNameLabel)
		self.customNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.customNameLabel.leadingAnchor.constraint(equalTo: self.customImageView.trailingAnchor,
														  constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.customNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
														   constant: TableViewConstants.tableViewCellRightInset),
			self.customNameLabel.centerYAnchor.constraint(equalTo: self.customImageView.centerYAnchor),
			])
		self.customNameLabel.font = Fonts.helvetica20
	}
}
