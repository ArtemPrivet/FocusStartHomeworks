//
//  UIViewController+isModallyPresented.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 09.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

extension UIViewController
{
	var isModallyPresented: Bool {
		let presentingIsModal = (presentingViewController != nil)
		let presentingIsNavigation =
			navigationController?.presentingViewController?.presentedViewController == navigationController
		let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

		return presentingIsModal || presentingIsNavigation || presentingIsTabBar
	}
}
