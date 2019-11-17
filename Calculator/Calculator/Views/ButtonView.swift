//
//  ButtonView.swift
//  Calculator
//
//  Created by Arkadiy Grigoryanc on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit
import SnapKit

enum Type
{
	case digit(Int)
	case operators(String)
}

final class ButtonView: UIView
{
	var title: String?

	lazy var button: UIButton = {
		let button = UIButton()
		button.setTitle(self.title, for: .normal)
		button.titleLabel?.font = UIFont(name: "FiraSans-Light", size: 36)
		//button.titleLabel?.textAlignment = .left
		return button
	}()

	init(type: Type) {
		var title = ""
		switch type {
		case .digit(let number): title = "\(number)"
		case .operators(let text): title = text
		}
		self.title = title
		super.init(frame: .zero)
		setup()
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func layoutSubviews() {
		layer.cornerRadius = min(bounds.width, bounds.height) / 2
		button.layer.cornerRadius = min(bounds.width, bounds.height) / 2
	}

	private func setup() {
		backgroundColor = .systemPink
		addSubview(button)
		setConstraints()
	}

	private func setConstraints() {
		button.snp.makeConstraints { maker in
			maker.edges.equalToSuperview()
		}
	}
}
