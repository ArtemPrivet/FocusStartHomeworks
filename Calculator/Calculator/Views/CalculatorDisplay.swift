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

//	var currentInput: Double {
//		get {
//			guard let text = self.text else { return 0 }
//			return Double(text) ?? 0
//		}
//		set {
//			if String(newValue).hasSuffix(".0") {
//				self.setText(String(String(newValue).dropLast(2)))
//			}
//			else {
//				self.setText(String(newValue))
//			}
//		}
//	}

	init() {
		super.init(frame: .zero)
//		self.delegate = pendingResult
		self.backgroundColor = .black
		translatesAutoresizingMaskIntoConstraints = false
	}
@available(*, unavailable)
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	func setText(_ text: String) {
		self.text = text
		self.textColor = .white
		self.font = UIFont(name: "FiraSans-Light", size: 30)
	}

//	private func addSwipeGestureToDispayLabel() {
//		let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(deleteSymbolFromLabel))
//		swipeGestureRecognizer.direction = [.left, .right]
//		self.addGestureRecognizer(swipeGestureRecognizer)
//		self.isUserInteractionEnabled = true
//	}
//
//	@objc func deleteSymbolFromLabel() {
//		guard isTyping, let labelText = displayLabel.text else { return }
//		let newText = String(labelText.dropLast())
//		if newText.count > 0 {
//			displayLabel.text = newText
//		}
//		else {
//			displayLabel.text = "0"
//			isTyping = false
//		}
//	}
}

//extension CalculatorDisplay: IPendingResult
//{
//	func showPendingResult(typing: String) {
//		self.setText(typing)
//		print("showPendingResult \(typing)")
//	}
//
//	func showResult(result: Double) {
////		currentInput = result
//	}
//}
