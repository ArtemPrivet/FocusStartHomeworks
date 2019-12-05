//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		// Services
		let networkService = MarvelAPIService()
		let decoderService = DecoderService()
		let imageDownloadService = ImageDownloadService()

		// Navigation controllers
		let navigationControllers = ItemType.allCases.map {
			createItemNavigation(itemType: $0,
								 networkService: networkService,
								 decoderService: decoderService,
								 imageDownloadServise: imageDownloadService)
		}

		// Tab bar controller
		let tabBarController = UITabBarController()
		tabBarController.viewControllers = navigationControllers
		tabBarController.tabBar.tintColor = UIColor(named: "tabBarTintColor")
		tabBarController.tabBar.unselectedItemTintColor = UIColor(named: "tabBarTintColor")

		// Window
		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = tabBarController
		window?.makeKeyAndVisible()

		return true
	}
}

// MARK: - Create controllers
private extension AppDelegate
{

	func createItemNavigation(
		itemType: ItemType,
		networkService: MarvelAPIService,
		decoderService: DecoderService,
		imageDownloadServise: ImageDownloadService) -> UINavigationController {

		let repository = ItemsRepository(jsonPlaceholderService: networkService,
										 decoderServise: decoderService,
										 imageDownloadServise: imageDownloadServise)

		let itemListViewController =
			ModulesFactory().getItemListModule(withRepository: repository,
											   itemType: itemType)

		if #available(iOS 13.0, *) {
			itemListViewController.view.backgroundColor = .systemBackground
		}
		else {
			itemListViewController.view.backgroundColor = .white
		}
		itemListViewController.title = itemType.title
		let tabBarItem: UITabBarItem =
			UITabBarItem(title: itemType.rawValue,
						 image: itemType.image.withRenderingMode(.alwaysOriginal),
						 selectedImage: nil)
		itemListViewController.tabBarItem = tabBarItem

		let navigationController = UINavigationController(rootViewController: itemListViewController)

		if #available(iOS 11.0, *) {
			navigationController.navigationBar.prefersLargeTitles = true
			navigationController.navigationItem.largeTitleDisplayMode = .never
		}

		return navigationController
	}
}
