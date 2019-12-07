//
//  DetailItemCollectionViewCell.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 05.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

final class DetailItemCollectionViewCell: UICollectionViewCell
{
	private var itemImageView = UIImageView()
	private var nameLabel = UILabel()
	private var infoLabel = UILabel()

	var currentImage: UIImage? {
		return itemImageView.image
	}

	var thumbPath: String?

	override var isHighlighted: Bool {
		didSet  {
			UIView.animate(withDuration: isHighlighted ? 0.3 : 0.1,
						   animations: { self.alpha = self.isHighlighted ? 0.3 : 1 })
		}
	}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setConstraints()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func configure(with title: String?, info: String?) {
		nameLabel.text = title
		infoLabel.text = info
	}

	func setImage(_ image: UIImage) {
		itemImageView.image = image
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
