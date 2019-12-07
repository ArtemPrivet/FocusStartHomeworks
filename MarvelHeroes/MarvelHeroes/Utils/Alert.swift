//
//  Alert.swift
//  MarvelHeroes
//
//  Created by Stanislav on 07/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

enum Alert
{
	case simpleAlert

	func showAlert(with text: String,
				   title: String,
				   buttonText: String,
				   viewController: UIViewController,
				   completion: (() -> Void)? = nil ) {
		switch self {
		case .simpleAlert:
			let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
			alert.addAction(UIAlertAction(title: buttonText, style: .default, handler: nil))
			viewController.present(alert, animated: true, completion: completion)
		}
	}
}
