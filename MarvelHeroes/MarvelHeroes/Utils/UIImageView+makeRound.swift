//
//  UIImageView+Extension.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import UIKit

extension UIImageView
{
	func makeRound() {
		self.contentMode = .scaleAspectFill
		self.layer.cornerRadius = (InterfaceConstants.cellHeight - 2 * InterfaceConstants.space) / 2
		self.clipsToBounds = true
	}
}
