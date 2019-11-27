//
//  Button.swift
//  Calculator
//
//  Created by Mikhail Medvedev on 16.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class Button: UIButton
{
	override var isSelected: Bool {
		didSet {
			animateWhenSelected()
		}
	}

	override var isHighlighted: Bool {
		didSet {
			animateWhenHighlighted()
		}
	}

	init() {
		super.init(frame: .zero)
		initialSetup()
	}

	@available(*, unavailable)
	required init(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	private func initialSetup() {
		titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 34)
		titleLabel?.textAlignment = .center
		backgroundColor = .darkGray
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		switch currentTitle {
		case Sign.divide, Sign.minus, Sign.multiply, Sign.plus, Sign.equals:
			titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 4, right: 0)
		case Sign.zero:
			titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.size.width / 2)
		default:
			titleEdgeInsets = UIEdgeInsets(top: 4, left: 0, bottom: 0, right: 0)
		}

		layer.cornerRadius = bounds.size.height / 2
	}

	private func animateWhenHighlighted() {
		UIView.animate(withDuration: 0.05,
					   delay: 0.0,
					   options: [.curveLinear],
					   animations: {
						switch self.currentTitle {
						case Sign.divide, Sign.multiply, Sign.minus, Sign.plus:
							self.alpha = self.isHighlighted ? 0.9 : 1
						case Sign.equals:
							self.setTitleColor(self.isHighlighted ? .systemOrange : .systemOrange, for: .highlighted)
							self.backgroundColor =
								self.isHighlighted ? .white : .systemOrange
						case Sign.clear, Sign.allClear, Sign.percent, Sign.changeSign:
							self.backgroundColor = self.isHighlighted ?  UIColor(white: 1, alpha: 0.9) : .lightGray
						default:
							self.backgroundColor = self.isHighlighted ?  UIColor(white: 1, alpha: 0.8) : .darkGray
						}
		})
	}

	private func animateWhenSelected() {
		switch currentTitle {
		case Sign.divide, Sign.multiply, Sign.minus, Sign.plus:
			self.alpha = 1
			UIView.animate(withDuration: 0.25,
						   delay: 0.0,
						   options: [.curveLinear],
						   animations: {
							if self.isSelected {
								self.setTitleColor(.systemOrange, for: .selected)
								self.backgroundColor = .white
							}
							else {
								self.setTitleColor(.white, for: .normal)
								self.backgroundColor = .systemOrange
							}
			})
		default: break
		}
	}
}
