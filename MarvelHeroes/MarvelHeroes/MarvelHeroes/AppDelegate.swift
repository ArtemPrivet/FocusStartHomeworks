//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 01.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


	var window: UIWindow?
	let builder = Builder()

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController()
		self.window!.rootViewController = navigationController
		navigationController.pushViewController(builder.createHeroesViewController(), animated: true)
		self.window?.makeKeyAndVisible()
		return true
	}
}

