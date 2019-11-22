//
//  ButtonView.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorButton: UIButton
{
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButton()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.bounds.height / 2
		if self.tag == 0 {
			self.contentHorizontalAlignment = .left
			self.contentEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.height / 2 - 7, bottom: 0, right: 0)
		}
		setButtonsColor()
	}

	private func setupButton() {
		backgroundColor	= Colors.colorGray
		titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 30)
		setTitleColor(.black, for: .normal)
	}

	private func setButtonsColor() {
		switch self.tag {
		case 0...10:
			self.backgroundColor = Colors.colorDarkGray
			self.setTitleColor(Colors.colorWhite, for: .normal)
		case 11...15:
			self.backgroundColor = Colors.colorOrange
			self.setTitleColor(Colors.colorWhite, for: .normal)
		case 16...18:
			self.backgroundColor = Colors.colorGray
			self.setTitleColor(Colors.colorBlack, for: .normal)
		default: break
		}
	}
}
