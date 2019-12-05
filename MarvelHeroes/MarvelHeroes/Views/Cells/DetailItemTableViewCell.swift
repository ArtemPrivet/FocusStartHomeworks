//
//  DetailItemTableViewCell.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import UIKit

final class DetailItemTableViewCell: UITableViewCell
{
	// MARK: Private properties
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()

	private let descriptionLabel: UILabel = {
		let label = UILabel()
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
		addSubview(titleLabel)
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
		iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8).isActive = true
		let iconImageViewBottomAnchor = NSLayoutConstraint(
			item: iconImageView,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: self,
			attribute: .bottom,
			multiplier: 1,
			constant: -8)
		iconImageViewBottomAnchor.priority = .defaultLow
		iconImageViewBottomAnchor.isActive = true

		// Name label constraints
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true

		// Description label constraints
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2).isActive = true
		descriptionLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
		descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor,
												   constant: -30).isActive = true
		descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: readableContentGuide.bottomAnchor,
												 constant: -8).isActive = true
		let descriptionLabelBottomAnchor = NSLayoutConstraint(
			item: descriptionLabel,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: self,
			attribute: .bottom,
			multiplier: 1,
			constant: -8)
		descriptionLabelBottomAnchor.priority = .defaultLow
		descriptionLabelBottomAnchor.isActive = true
	}
}

// MARK: IItemTableViewCell
extension DetailItemTableViewCell: IItemTableViewCell
{
	func configure(using viewModel: IItemViewModel) {
		titleLabel.text = viewModel.title
		guard let description = viewModel.description else { return }
		descriptionLabel.text = (description.isEmpty == false) ? description : "No info"
	}

	func updateIcon(image: UIImage?) {
		iconImageView.image = image
	}
}
