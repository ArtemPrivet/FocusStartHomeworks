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
	let builder = Builder()

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		self.window = UIWindow(frame: UIScreen.main.bounds)
		let navigationController = UINavigationController(rootViewController: builder.createCharactersViewController())
		self.window?.rootViewController = navigationController
		self.window?.makeKeyAndVisible()
		return true
	}
}
