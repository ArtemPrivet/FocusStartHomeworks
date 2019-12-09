//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		window = UIWindow(frame: UIScreen.main.bounds)

		let networkService = NetworkService()
		let jsonDataFetcher = JSONDataFetcher(networkService: networkService)
		let marvelItemsRepository = MarvelItemsRepository(networkService: networkService, jsonDataFetcher: jsonDataFetcher)

		let modulesFactory = ModulesFactory(
			networkService: networkService,
			jsonDataFetcher: jsonDataFetcher,
			repository: marvelItemsRepository
		)

		window?.rootViewController = modulesFactory.createTabBarControllerModule()
		window?.makeKeyAndVisible()

		return true
	}
}
