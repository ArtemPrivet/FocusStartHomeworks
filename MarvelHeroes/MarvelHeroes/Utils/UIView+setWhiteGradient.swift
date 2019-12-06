//
//  UIView+Extension.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

extension UIView
{
//Устанавливает градиент поверх view
	func setWhiteGradientAbove() {
		let gradientLayer = CAGradientLayer()
		gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
		gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
		let color = UIColor.white
		gradientLayer.colors = [
			color.withAlphaComponent(0.0).cgColor,
			color.withAlphaComponent(0.2).cgColor,
			color.withAlphaComponent(0.5).cgColor,
		]
		gradientLayer.locations = [
			NSNumber(value: 0.0),
			NSNumber(value: 0.5),
			NSNumber(value: 0.8),
		]
		gradientLayer.frame = self.bounds
		self.layer.mask = gradientLayer
	}
}
