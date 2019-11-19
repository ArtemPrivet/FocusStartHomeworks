//
//  RoundButton.swift
//  Calculator
//
//  Created by Igor Shelginskiy on 11/19/19.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//
import UIKit

final class RoundButton: UIButton
{
	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.bounds.height / 2
	}
}
