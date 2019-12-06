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
		self.layer.cornerRadius = (Constants.cellHeight - 2 * Constants.space) / 2
		self.clipsToBounds = true
	}
}
