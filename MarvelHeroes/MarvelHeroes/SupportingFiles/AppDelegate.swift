//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by MacBook Air on 01.12.2019.
//  Copyright © 2019 MacBook Air. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let viewController = Factory().getCharacterViewController()
		let navigationRoot = UINavigationController(rootViewController: viewController)
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = navigationRoot
		window?.makeKeyAndVisible()
		return true
	}
}
