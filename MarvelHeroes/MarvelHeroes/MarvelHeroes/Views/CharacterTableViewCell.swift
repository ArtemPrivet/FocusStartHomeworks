//
//  CharacterTableViewCell.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import UIKit

class CharacterTableViewCell: UITableViewCell {

	// MARK: Private properties
	private let nameLabel: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.textAlignment = .left
		return label
	}()

	private let descriptionLabel: UILabel = {
		let label = UILabel()
		label.textColor = .black
		label.font = UIFont.systemFont(ofSize: 14)
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()

	private let iconImageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 25
		return imageView
	}()

	// MARK: Initialization
	override init(style: CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setup()
		setConstraints()
	}

	@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private methods
	private func setup() {
		addSubview(iconImageView)
		addSubview(nameLabel)
		addSubview(descriptionLabel)

		accessoryType = .disclosureIndicator
	}

	private func setConstraints() {
		// Avatar image view constraints
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8).isActive = true
		iconImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true

		// Name label constraints
		nameLabel.translatesAutoresizingMaskIntoConstraints = false
		nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		nameLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
		nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
		nameLabel.heightAnchor.constraint(equalToConstant: 21).isActive = true

		// description label constraints
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2).isActive = true
		descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
		descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8).isActive = true
		descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
		descriptionLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 21).isActive = true
	}

	// MARK: Methods
	func configure(using viewModel: Character) {
		//avatarImageView.image = #imageLiteral(resourceName: "placeholder")
		nameLabel.text = viewModel.name
		descriptionLabel.text = viewModel.resourceURI
	}

	func updateIcon(image: UIImage) -> Void {
		iconImageView.image = image
	}
}
