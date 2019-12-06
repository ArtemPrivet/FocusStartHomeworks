//
//  StubView.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 04.12.2019.
//

import UIKit

final class StubView: UIView
{
	// MARK: Private properties
	private var titleLabel: UILabel = {
		let label = UILabel()
		label.font = UIFont.systemFont(ofSize: 16)
		label.numberOfLines = 0
		label.text = "Start typing text"
		label.textAlignment = .center
		return label
	}()

	private let imageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "search_stub"))
		imageView.contentMode = .scaleAspectFit
		return imageView
	}()

	// MARK: Initialization
	init() {
		super.init(frame: .zero)
		setup()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: Private methods
	private func setup() {
		addSubview(imageView)
		addSubview(titleLabel)

		setConstraints()
	}

	private func setConstraints() {

		// Image view constraints
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		imageView.heightAnchor.constraint(equalTo: widthAnchor).isActive = true

		// Title label constraints
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
		titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 8).isActive = true
		titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
	}

	// MARK: Internal methods
	func setTitle(_ text: String) {
		titleLabel.text = text
	}
}
