//
//  ButtonView.swift
//  Calculator
//
//  Created by Kirill Fedorov on 17.11.2019.
//  Copyright © 2019 Artem Orlov. All rights reserved.
//

import UIKit

final class ButtonView: UIButton
{
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupButton()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setupButton()
	}

	func setupButton() {
		setTitleColor(.white, for: .normal)

		backgroundColor	= Colors.colorGray
		titleLabel?.font = UIFont(name: "FiraSans-Regular", size: 30)
//		setTitle(String(self.tag), for: .normal)
		setTitleColor(.black, for: .normal)
	}
}
