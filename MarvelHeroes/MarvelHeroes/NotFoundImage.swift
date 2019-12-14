//
//  NotFoundImage.swift
//  MarvelHeroes
//
//  Created by Антон on 11.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import UIKit
protocol INotFoundImageView
{
	func showImageView(subview: UIView, text: String)
	func hideImageView()
}
final class NotFoundImageView: UIView
{
	let viewContainer = UIView()
	let label = UILabel()
	let imageView = UIImageView()
}
extension NotFoundImageView: INotFoundImageView
{
	func showImageView(subview: UIView, text: String) {
		subview.addSubview(viewContainer)
		let size = subview.bounds.size
		viewContainer.translatesAutoresizingMaskIntoConstraints = false
		viewContainer.heightAnchor.constraint(equalToConstant: size.height / 1.3).isActive = true
		viewContainer.widthAnchor.constraint(equalToConstant: size.width / 1.3).isActive = true
		viewContainer.centerXAnchor.constraint(equalTo: subview.centerXAnchor).isActive = true
		viewContainer.centerYAnchor.constraint(equalTo: subview.centerYAnchor).isActive = true
		viewContainer.addSubview(label)
		viewContainer.addSubview(imageView)
		let image = #imageLiteral(resourceName: "search_stub")
		imageView.image = image
		imageView.clipsToBounds = true
		imageView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			imageView.leadingAnchor.constraint(equalTo: viewContainer.leadingAnchor),
			imageView.trailingAnchor.constraint(equalTo: viewContainer.trailingAnchor),
			imageView.topAnchor.constraint(equalTo: viewContainer.topAnchor),
		])
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
			label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
			label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 0),
			label.heightAnchor.constraint(greaterThanOrEqualToConstant: 10),
		])
		label.numberOfLines = 0
		label.textColor = #colorLiteral(red: 0.6744592786, green: 0.6745393872, blue: 0.6744223237, alpha: 1)
		label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
		label.textAlignment = .center
		label.text = text
		label.sizeToFit()
	}

	func hideImageView() {
		self.viewContainer.removeFromSuperview()
		self.label.removeFromSuperview()
		self.imageView.removeFromSuperview()
	}
}
