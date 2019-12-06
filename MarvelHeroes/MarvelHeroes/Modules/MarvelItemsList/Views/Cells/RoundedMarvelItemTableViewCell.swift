//
//  RoundedMarvelItemTableViewCell.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 04.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

final class RoundedMarvelItemTableViewCell: MarvelItemTableViewCell
{
	static let id = "RoundedCell"

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		infoLabel.text = "No info"
		setConstraints()
	}
	override func setConstraints() {
		itemImageView.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		infoLabel.translatesAutoresizingMaskIntoConstraints = false

		nameLabel.numberOfLines = 2
		nameLabel.lineBreakMode = .byWordWrapping
		infoLabel.font = .preferredFont(forTextStyle: .caption1)
		infoLabel.textColor = .darkGray

		contentView.addSubview(itemImageView)
		contentView.addSubview(nameLabel)
		contentView.addSubview(infoLabel)

		itemImageView.layer.cornerRadius = (Metrics.rowHeight - Metrics.imageViewMargin) / 2
		itemImageView.clipsToBounds = true

		NSLayoutConstraint.activate([
			itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
			itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
			itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			itemImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -Metrics.imageViewMargin),
			itemImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -Metrics.imageViewMargin),

			nameLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
			nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
			nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

			infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
			infoLabel.leadingAnchor.constraint(equalTo: itemImageView.trailingAnchor, constant: 16),
			infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
		])
	}
}
