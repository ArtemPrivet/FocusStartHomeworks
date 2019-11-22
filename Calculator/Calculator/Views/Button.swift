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
	var isRounded = true

	override var isSelected: Bool {
		didSet {
			switch currentTitle {
			case Sign.divide:
				UIView.animate(withDuration: 0.5,
							   delay: 0.0,
							   options: [.curveLinear],
							   animations: {
								self.setBackgroundImage(UIImage(named: self.isSelected ? "divideSReversed" : "divideS"), for: .selected) },
							   completion: nil )
			case Sign.divide, Sign.multiply, Sign.minus, Sign.plus:
				UIView.animate(withDuration: 0.5,
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
				},
							   completion: nil)

			default: break
			}
		}
	}

	override var isHighlighted: Bool {
		didSet {
			UIView.animate(withDuration: 0.3,
						   delay: 0.0,
						   options: [.curveLinear],
						   animations: {
							switch self.currentTitle {
							case Sign.divide:
								self.setBackgroundImage(UIImage(named: self.isHighlighted ? "divideSReversed" : "divideS"), for: .normal)
							case Sign.multiply, Sign.minus, Sign.plus:
								break
							case Sign.equals:
								self.backgroundColor =
									self.isHighlighted ? UIColor(white: 1, alpha: 0.8) : .systemOrange
							case Sign.clear, Sign.allClear, Sign.percent, Sign.changeSign:
								self.backgroundColor = self.isHighlighted ?  UIColor(white: 1, alpha: 0.9) : .lightGray
							default:
								self.backgroundColor = self.isHighlighted ?  UIColor(white: 1, alpha: 0.8) : .darkGray
							}
			},
						   completion: nil
			)
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
		titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 32)
		titleLabel?.textAlignment = .center
		backgroundColor = .darkGray
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if isRounded {
			bounds.size.width = bounds.size.height
			titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
		}
		else {
			//offset zero button title to left side
			titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: bounds.size.width / 2)
		}
		layer.cornerRadius = bounds.size.height / 2
	}
}
