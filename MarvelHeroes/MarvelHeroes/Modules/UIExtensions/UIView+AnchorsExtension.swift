//
//  UIView+AnchorsExtension.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 05.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

extension UIView
{
	func fillSuperview() {
		anchor(top: superview?.topAnchor,
			   leading: superview?.leadingAnchor,
			   bottom: superview?.bottomAnchor,
			   trailing: superview?.trailingAnchor)
	}

	func anchorSize(to view: UIView) {
		widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
		heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
	}

	func anchor(top: NSLayoutYAxisAnchor?,
				leading: NSLayoutXAxisAnchor?,
				bottom: NSLayoutYAxisAnchor?,
				trailing: NSLayoutXAxisAnchor?,
				padding: UIEdgeInsets = .zero,
				size: CGSize = .zero) {
		translatesAutoresizingMaskIntoConstraints = false

		if let top = top {
			topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
		}

		if let leading = leading {
			leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
		}

		if let bottom = bottom {
			bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
		}

		if let trailing = trailing {
			trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
		}

		if size.width != 0 {
			widthAnchor.constraint(equalToConstant: size.width).isActive = true
		}

		if size.height != 0 {
			heightAnchor.constraint(equalToConstant: size.height).isActive = true
		}
	}
}
