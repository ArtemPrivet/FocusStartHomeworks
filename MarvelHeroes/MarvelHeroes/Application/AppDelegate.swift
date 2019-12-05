//
//  AppDelegate.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{

	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)

		let tabBarController = UITabBarController(nibName: nil, bundle: nil)
		tabBarController.tabBar.shadowImage = UIImage()
		let comicsVC = Factory().createComicsModule()
		comicsVC.tabBarItem = UITabBarItem(title: "Comics", image: #imageLiteral(resourceName: "comic"), tag: 2)

		let authorVC = Factory().createAuthorsModule()
		authorVC.tabBarItem = UITabBarItem(title: "Authors", image: #imageLiteral(resourceName: "writer"), tag: 3)

		tabBarController.addChild(UINavigationController(rootViewController: Factory().createCharactersModule()))
		tabBarController.addChild(UINavigationController(rootViewController: comicsVC))
		tabBarController.addChild(UINavigationController(rootViewController: authorVC))

		window?.rootViewController = tabBarController
		window?.makeKeyAndVisible()
		return true
	}
}
