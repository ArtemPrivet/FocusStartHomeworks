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
		window.makeKeyAndVisible()
		return window
	}()

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		let networkService = NetworkService()
		let repository = Repository(networkService: networkService)
		let factory = Factory(repository: repository)

		let tabBarController = factory.createTabBarController()
		let heroesNavigationController = factory.createHeroesNavigationController()
		let comicsNavigationController = factory.createComicsNavigationController()
		let authorsNavigationController = factory.createAuthorsNavigationController()
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
