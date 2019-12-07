//
//  ItemTableViewCell.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 03.12.2019.
//

import UIKit

final class ItemTableViewCell: UITableViewCell
{
	// MARK: Private properties
	private let titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.boldSystemFont(ofSize: 16)
		label.textAlignment = .left
		label.numberOfLines = 0
		return label
	}()

	private let iconImageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
		imageView.contentMode = .scaleAspectFit
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
		titleLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 8).isActive = true
		titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
	}
}

// MARK: IItemTableViewCell
extension ItemTableViewCell: IItemTableViewCell
{
	func configure(using viewModel: IItemViewModel) {
		titleLabel.text = viewModel.title
	}

	func updateIcon(image: UIImage?) {
		iconImageView.image = image
	}
}
