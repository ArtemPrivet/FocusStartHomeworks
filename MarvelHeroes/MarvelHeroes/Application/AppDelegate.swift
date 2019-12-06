//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{

	lazy var window: UIWindow? = {
		let window = UIWindow(frame: UIScreen.main.bounds)
		window.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
		window.makeKeyAndVisible()
		return window
	}()

	lazy var tabBarController: UITabBarController = {
		let tabBarController = UITabBarController(nibName: nil, bundle: nil)
		return tabBarController
	}()

	let factory = Factory()

	lazy var heroesNavigationController: UINavigationController = {
		let heroesNavigationController = UINavigationController(nibName: nil, bundle: nil)
		heroesNavigationController.navigationBar.prefersLargeTitles = true
		heroesNavigationController.tabBarItem = UITabBarItem(title: "Heroes", image: UIImage(named: "shield"), tag: 0)
		return heroesNavigationController
	}()

	lazy var comicsNavigationController: UINavigationController = {
		let comicsNavigationController = UINavigationController(nibName: nil, bundle: nil)
		comicsNavigationController.tabBarItem = UITabBarItem(title: "Comics", image: UIImage(named: "comic"), tag: 1)
		comicsNavigationController.navigationBar.prefersLargeTitles = true
		return comicsNavigationController
	}()

	lazy var authorsNavigationController: UINavigationController = {
		let authorsNavigationController = UINavigationController(nibName: nil, bundle: nil)
		authorsNavigationController.tabBarItem = UITabBarItem(title: "Authors", image: UIImage(named: "writer"), tag: 2)
		authorsNavigationController.navigationBar.prefersLargeTitles = true
		return authorsNavigationController
	}()

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let heroesVC = factory.createHeroesModule()
		let comicsVC = factory.createComicsModule()
		let authorsVC = factory.createAuthorsModule()
		heroesNavigationController.pushViewController(heroesVC, animated: false)
		comicsNavigationController.pushViewController(comicsVC, animated: false)
		authorsNavigationController.pushViewController(authorsVC, animated: false)
		tabBarController.setViewControllers(
			[
				heroesNavigationController,
				comicsNavigationController,
				authorsNavigationController,
			],
			animated: false)
		window?.rootViewController = tabBarController
		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}
}
