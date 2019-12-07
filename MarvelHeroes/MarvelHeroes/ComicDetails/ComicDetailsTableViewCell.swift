//
//  ComicDetailsTableViewCell.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 06/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

final class ComicDetailsTableViewCell: UITableViewCell
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
	let authorNameLabel = UILabel()
	let authorImageView = UIImageView()

	func settingsForImageView() {
		self.addSubview(self.authorImageView)
		self.authorImageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.authorImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor,
														 constant: TableViewConstants.tableViewCellLeftInset),
			self.authorImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
			self.authorImageView.heightAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageHeight),
			self.authorImageView.widthAnchor.constraint(equalToConstant: TableViewConstants.tableViewCellImageWidth),
			])
		self.authorImageView.clipsToBounds = true
		self.authorImageView.contentMode = .scaleAspectFit
	}

	func settingsForNameLabel() {
		self.addSubview(self.authorNameLabel)
		self.authorNameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			self.authorNameLabel.leadingAnchor.constraint(equalTo: self.authorImageView.trailingAnchor,
														  constant: TableViewConstants.tableViewCellSpaceBetweenElements),
			self.authorNameLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,
														   constant: TableViewConstants.tableViewCellRightInset),
			self.authorNameLabel.centerYAnchor.constraint(equalTo: self.authorImageView.centerYAnchor),
			])
		self.authorNameLabel.font = UIFont(name: "Helvetica", size: 20)
	}
}
