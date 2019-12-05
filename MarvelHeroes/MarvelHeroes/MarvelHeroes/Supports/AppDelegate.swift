//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/1/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let tabBarController = UITabBarController()
		let heroVC = ModulesFactory().getHeroModule()
		let navigationHeroVC = UINavigationController(rootViewController: heroVC)
		navigationHeroVC.tabBarItem.image = UIImage(named: "shield")
		let navigationComicsVC = UINavigationController(rootViewController: ComicsViewController())
		navigationComicsVC.tabBarItem.image = UIImage(named: "comic")
		let navigationAuthorVC = UINavigationController(rootViewController: AuthorViewController())
		navigationAuthorVC.tabBarItem.image = UIImage(named: "writer")
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = tabBarController
		tabBarController.viewControllers = [navigationHeroVC, navigationComicsVC, navigationAuthorVC]
		window?.makeKeyAndVisible()
		return true
	}


}

