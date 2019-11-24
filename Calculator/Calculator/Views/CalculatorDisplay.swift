//
//  CalculatorDisplay.swift
//  Calculator
//
//  Created by Ekaterina Koreneva on 17/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorDisplay: UILabel
{
	weak var delegateToPR: IDisplayInfo?
	private var pendingResult = PendingResult()

	init() {
		super.init(frame: .zero)
		self.backgroundColor = .black
		addSwipeToDispay()
		translatesAutoresizingMaskIntoConstraints = false
	}
@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func setText(_ text: Double) {
		if String(text).hasSuffix("inf") {
			self.text = "Ошибка"
		}
		else {
			self.text = text.formattedWithSeparator
		}
//		}
		self.textColor = .white
		self.textAlignment = .right
		self.font = UIFont(name: "FiraSans-Light", size: 94)
		self.adjustsFontSizeToFitWidth = true
		self.minimumScaleFactor = 0.5
	}

	private func addSwipeToDispay() {
		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deleteRightSymbol))
		swipeGestureRecognizer.direction = [.left, .right]
		self.addGestureRecognizer(swipeGestureRecognizer)
		self.isUserInteractionEnabled = true
	}

	@objc func deleteRightSymbol() {
		let newText = String(self.text?.dropLast() ?? "")
		let swippedText = String(newText.filter { !" ".contains($0) })
		self.setText(Double(swippedText) ?? 0)
		pendingResult.displayingNow(nowText: self.text)
	}
}
