//
//  StackButtons.swift
//  Calculator
//
//  Created by Igor Shelginskiy on 11/19/19.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//
import SnapKit
import UIKit

final class StackButtons: UIView
{
	private var digitAndSymbols = [
		"AC", "⁺∕₋", "%", "÷", "7", "8", "9", "×", "4", "5", "6", "-", "1", "2", "3", "+", "0", ",", "=",
	]
	private var colorArray: [UIColor] = [#colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1), #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1), #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)]
	var stackOfStacks = UIStackView()
	var stackArray = [UIStackView]()
	var buttons = [RoundButton]()
	var buttonsInStack = [RoundButton]()

	init() {
		super.init(frame: .zero)
		backgroundColor = .black
		stackOfStacks.axis = .vertical
		stackOfStacks.alignment = .fill
		stackOfStacks.distribution = .fillEqually
		stackOfStacks.spacing = 10
		formingStack()
		addSubview(stackOfStacks)
		stackOfStacks.snp.makeConstraints { maker in
			maker.edges.equalToSuperview()
		}
		translatesAutoresizingMaskIntoConstraints = false
	}
	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	func formingStack() {
		addButtonsToArray()
		addButtonsToStack()
		for stack in stackArray {
			stackOfStacks.addArrangedSubview(stack)
		}
	}
	func addButtonsToArray() {
		for element in 0..<digitAndSymbols.count {
			let button = RoundButton()
			button.titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 36)
			switch digitAndSymbols[element] {
			case "AC", "%", "⁺∕₋":
				button.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
				button.setTitle(digitAndSymbols[element], for: .normal)
				button.setTitleColor(.black, for: .normal)
			case "÷", "×", "-", "+", "=":
				button.backgroundColor = #colorLiteral(red: 1, green: 0.5825584531, blue: 0, alpha: 1)
				button.setTitle(digitAndSymbols[element], for: .normal)
			default:
				button.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
				button.setTitle(digitAndSymbols[element], for: .normal)
			}
			if button.titleLabel?.text == "0" {
				button.contentEdgeInsets.right = 80
				button.snp.makeConstraints { maker in
					maker.width.equalTo(button.snp.height).multipliedBy(2)
				}
			}
			else {
				button.snp.makeConstraints { maker in
					maker.width.equalTo(button.snp.height).multipliedBy(1)
				}
			}
				buttons.append(button)
		}
	}
	func addButtonsToStack() {
		for _ in 1...5 {
			stackArray.append(UIStackView())
		}
		stackArray.forEach{stack in
			stack.axis = .horizontal
			stack.alignment = .fill
			stack.distribution = .fillEqually
			stack.spacing = 10
		}
		stackArray[4].distribution = .fill

		for index in 0..<buttons.count {
			switch index {
			case 0...3: stackArray[0].addArrangedSubview(buttons[index])
			case 4...7: stackArray[1].addArrangedSubview(buttons[index])
			case 8...11: stackArray[2].addArrangedSubview(buttons[index])
			case 12...15: stackArray[3].addArrangedSubview(buttons[index])
			default: stackArray[4].addArrangedSubview(buttons[index])
			}
		}
	}
}
