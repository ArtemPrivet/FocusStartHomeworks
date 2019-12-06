//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		window = UIWindow(frame: UIScreen.main.bounds)
//		let moduleFactory = ModuleFactory()
//		let tabBarController = moduleFactory.createTabBarViewController()
//		window?.rootViewController = tabBarController
//		window?.makeKeyAndVisible()
		return true
	}
}
