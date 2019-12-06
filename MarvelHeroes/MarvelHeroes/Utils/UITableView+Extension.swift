//
//  UITableView+Extension.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import UIKit

extension UITableView
{
//В случае когда нет записей в таблице показываем картинку
	func setEmptyImage(messageText: String) {
		let imageView = UIImageView(image: UIImage(named: "search_stub"))
		imageView.contentMode = .center
		let messageLabel = UILabel()
		messageLabel.text = messageText
		messageLabel.textColor = .gray
		messageLabel.numberOfLines = 0
		messageLabel.textAlignment = .center
		messageLabel.font = UIFont.systemFont(ofSize: 20, weight: .medium)
		let view = UIView()
		view.addSubview(imageView)
		view.addSubview(messageLabel)
		imageView.translatesAutoresizingMaskIntoConstraints = false
		messageLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
			imageView.heightAnchor.constraint(equalToConstant: 150),
			messageLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
			messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
			messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20 ),
			])
		self.backgroundView = view
	}

	func restore() {
		self.backgroundView = nil
	}
}
