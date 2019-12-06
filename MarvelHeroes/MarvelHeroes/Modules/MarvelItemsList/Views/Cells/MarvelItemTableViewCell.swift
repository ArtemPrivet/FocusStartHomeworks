//
//  MarvelItemTableViewCell.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 03.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//  swiftlint:disable required_final

import UIKit

class MarvelItemTableViewCell: UITableViewCell
{
	static let identifier = "PortraitCell"

	var itemImageView = UIImageView(image: UIImage(named: "placeholder"))
	var nameLabel = UILabel()
	var infoLabel = UILabel()

	var imageUrlPath: String?

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		accessoryType = .disclosureIndicator
		setConstraints()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with hero: Hero) {
		nameLabel.text = hero.name
		guard let description = hero.description else { return }
		if description.isEmpty == false, description != " " {
			infoLabel.text = hero.description
		}
	}

	func configure(with comics: Comics) {
		nameLabel.text = comics.title
	}

	func configure(with author: Author) {
		nameLabel.text = author.fullName
	}

	func setConstraints() {

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

		NSLayoutConstraint.activate([
			itemImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
			itemImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
			itemImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
			itemImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, constant: -Metrics.imageViewMargin * 4),
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
