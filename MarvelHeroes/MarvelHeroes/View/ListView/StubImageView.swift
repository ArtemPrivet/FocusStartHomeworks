//
//  StubImageView.swift
//  MarvelHeroes
//
//  Created by Stanislav on 07/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

final class StubImageView: UIView
{
	init(messageText: String) {
		super.init(frame: .zero)
		let imageView = UIImageView(image: UIImage(named: "search_stub"))
		let messageLabel = UILabel()
		imageView.contentMode = .scaleAspectFit
		messageLabel.text = messageText
		messageLabel.textColor = .gray
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		self.addSubview(imageView)
		self.addSubview(messageLabel)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 150),
			imageView.heightAnchor.constraint(equalToConstant: 150),
			messageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
			messageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -50),
			messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20 ),
			])
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
