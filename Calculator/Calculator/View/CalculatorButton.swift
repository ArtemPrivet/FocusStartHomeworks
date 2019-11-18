//
//  GeneralButton.swift
//  Calculator
//
//  Created by Максим Шалашников on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorButton: UIView
{
	let button = UIButton()

	init() {
		super.init(frame: .zero)
		addSubview(button)
	}
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func layoutSubviews() {
		super.layoutSubviews()
		button.frame = bounds
	}
	func setBackgroundColor(hex color: String) {
		backgroundColor = UIColor(hexString: color)
	}
	func setBackgroundColor(UIColor color: UIColor) {
		backgroundColor = color
	}
	func setTextColor(hex color: String) {
		button.setTitleColor(UIColor(hexString: color), for: .normal)
	}
	func setTextColor(UIColor color: UIColor) {
		button.setTitleColor(color, for: .normal)
	}
	func setText(_ text: String) {
		guard let font = UIFont(name: "FiraSans-Regular", size: 36) else { return }
		button.titleLabel?.font = font
		button.setTitle(text, for: .normal)
	}
	func setImage(imageName: String) {
		guard let image = UIImage(named: imageName) else { return }
		button.setImage(image, for: .normal)
	}
}
