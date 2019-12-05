//
//  UIView+Gradient.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 03.12.2019.
//

import UIKit

extension UIView
{
	/// For insert layer in Foreground
	@discardableResult
	func addGradientLayerInForeground(frame: CGRect? = nil, colors: [UIColor]) -> CAGradientLayer {
		let gradient = CAGradientLayer()
		gradient.frame = frame ?? self.bounds
		gradient.colors = colors.map { $0.cgColor }
		layer.addSublayer(gradient)
		return  gradient
	}
}
