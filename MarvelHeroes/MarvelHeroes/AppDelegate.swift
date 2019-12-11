//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?
	let builder = ControllerBuilder()

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let tabBarController = UITabBarController()
		let charactersViewController = builder.createCharactersViewController()
		let charactersNavigationController = UINavigationController(rootViewController: charactersViewController)
		tabBarController.viewControllers = [charactersNavigationController]
		self.window?.rootViewController = tabBarController
		self.window?.makeKeyAndVisible()
		return true
	}
}
