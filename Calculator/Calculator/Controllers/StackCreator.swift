//
//  StackCreator.swift
//  Calculator
//
//  Created by Stanislav on 19/11/2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

struct StackCreator
{
	private let spaceBetweenButtons: CGFloat = 14

	//Создаем стэк из входящего массива кнопок
	func createStackFromButtons(buttons: [UIButton?]) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: buttons.compactMap{ $0 })
		setUpHorizontalStackView(stackView: stackView)
		return stackView
	}
	func createVerticalStack(from stacks: [UIStackView]) -> UIStackView {
		let stackView = UIStackView(arrangedSubviews: stacks)
		setUpVerticalStackView(stackView: stackView)
		stacks.forEach{ setHorizontalStackConstraints(stackView: $0, parentStackView: stackView) }
		return stackView
	}
	//Устанавливаем свойства для UIStackView
	private func setUpHorizontalStackView(stackView: UIStackView) {
		stackView.axis = .horizontal
		stackView.distribution = .fillProportionally
		stackView.alignment = .fill
		stackView.spacing = spaceBetweenButtons
		stackView.translatesAutoresizingMaskIntoConstraints = false
	}
	//Устанавливаем свойства для главного StackView
	func setUpVerticalStackView(stackView: UIStackView) {
		stackView.axis = .vertical
		stackView.distribution = .fillEqually
		stackView.alignment = .fill
		stackView.spacing = spaceBetweenButtons
		stackView.translatesAutoresizingMaskIntoConstraints = false
	}
	//Устанавливаем topAnchor и TrailingAnchor для стека по размеру родительского
	private func setHorizontalStackConstraints(stackView: UIStackView, parentStackView: UIStackView) {
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: parentStackView.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: parentStackView.trailingAnchor),
		])
	}
	//Устанавливаем констрейнты для вертикального стека
	func setVerticalStackConstraints(stackView: UIStackView, safeAreaMargins: UILayoutGuide) {
		NSLayoutConstraint.activate([
			stackView.leadingAnchor.constraint(equalTo: safeAreaMargins.leadingAnchor),
			stackView.trailingAnchor.constraint(equalTo: safeAreaMargins.trailingAnchor),
			stackView.bottomAnchor.constraint(equalTo: safeAreaMargins.bottomAnchor),
		])
	}
}
