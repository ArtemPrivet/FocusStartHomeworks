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

	override var isHighlighted: Bool {
		didSet {
			switch self.tag {
			case 0...10:
				UIView.animate(withDuration: 0.2) { [weak self] in
					guard let self = self else { return }
					self.backgroundColor = self.isHighlighted ? Colors.colorDarkGray.lighter(by: 30) : Colors.colorDarkGray
				}
			case 11...15:
				UIView.animate(withDuration: 0.2) { [weak self] in
					guard let self = self else { return }
					self.backgroundColor = self.isHighlighted ? UIColor.white : Colors.colorOrange
				}
			case 16...18:
				UIView.animate(withDuration: 0.2) { [weak self] in
					guard let self = self else { return }
					self.backgroundColor = self.isHighlighted ? Colors.colorGray.lighter(by: 30) : Colors.colorGray
				}
			default: break
			}
		}
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		self.layer.cornerRadius = self.bounds.height / 2
		if self.tag == 0 {
			self.contentHorizontalAlignment = .left
			self.contentEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.height / 2 - 7, bottom: 0, right: 0)
		}
	}

	private func setupButton() {
		titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 30)
	}
}
