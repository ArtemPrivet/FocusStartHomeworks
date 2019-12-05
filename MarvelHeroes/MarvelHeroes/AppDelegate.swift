//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Антон on 01.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		let mainScreen = MainScreen()
		let navigationController = UINavigationController(rootViewController: mainScreen)
		if #available(iOS 11.0, *) {
			navigationController.navigationBar.prefersLargeTitles = true
		}
		window?.rootViewController = navigationController
		window?.makeKeyAndVisible()
		// Override point for customization after application launch.
		return true
	}
}
