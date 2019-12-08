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

	private func addNavigationsVC() -> [UINavigationController] {
		let heroVC = ModulesFactory().getHeroModule()
		let naviHeroVC = UINavigationController(rootViewController: heroVC)
		naviHeroVC.tabBarItem.image = UIImage(named: "shield")
		let naviComicsVC = UINavigationController(rootViewController: ComicsViewController())
		naviComicsVC.tabBarItem.image = UIImage(named: "comic")
		let naviAuthorVC = UINavigationController(rootViewController: AuthorViewController())
		naviAuthorVC.tabBarItem.image = UIImage(named: "writer")
		return [naviHeroVC, naviComicsVC, naviAuthorVC]
	}

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let tabBarController = UITabBarController()
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = tabBarController
		tabBarController.viewControllers = addNavigationsVC()
		window?.makeKeyAndVisible()
		return true
	}
}
