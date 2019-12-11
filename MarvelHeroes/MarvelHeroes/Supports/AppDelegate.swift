//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/1/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

@UIApplicationMain

final class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		let factory = ModulesFactory()
		window?.rootViewController = factory.addTabBarViewController()
		window?.makeKeyAndVisible()
		return true
	}
}
