//
//  GeneralButton.swift
//  Calculator
//
//  Created by Максим Шалашников on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class CalculatorButton: UIButton
{
	var identifier: String?

	//не забыть исправить
	init(of type: TypeOfButton, with title: String) {
		super.init(frame: .zero)
		chooseTypeAndCreate(of: type, with: title)
	}
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	private func chooseTypeAndCreate(of type: TypeOfButton, with title: String) {
		switch type {
		case .digit:
			setTitleAndFont(title: title, color: .white)
			if title == "0" {
				contentHorizontalAlignment = .left
				contentEdgeInsets = UIEdgeInsets(top: 0, left: 33, bottom: -5, right: 0)
			}
			else {
				contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
			}
			backgroundColor = UIColor(hexString: "#333333")
		case .operation:
			identifier = title
			backgroundColor = UIColor(hexString: "#FF9500")
			//XCode вылетает если назвать файл "/"
			if title == "/" {
				guard let image = UIImage(named: "div") else { return }
				setImage(image, for: .normal)
			}
			else {
				guard let image = UIImage(named: title) else { return }
				setImage(image, for: .normal)
			}
		case .symbolic:
			contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: -5, right: 0)
			backgroundColor = UIColor(hexString: "#C4C4C4")
			if title == "AC" {
				identifier = title
				setTitleAndFont(title: title, color: .black)
			}
			else {
				identifier = title
				guard let image = UIImage(named: title) else { return }
				setImage(image, for: .normal)
			}
		}
	}
	private func setTitleAndFont(title: String, color: UIColor) {
		guard let customFont = UIFont(name: "FiraSans-Regular", size: 36) else { return }
		setTitle(title, for: .normal)
		setTitleColor(color, for: .normal)
		titleLabel?.font = customFont
	}
}
