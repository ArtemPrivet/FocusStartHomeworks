//
//  AppDelegate.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?

	func application(
		_ application: UIApplication,
		didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		let networkService = MarvelAPIService()
		let decoderService = DecoderService()
		let imageDownloadService = ImageDownloadService()
		let repository = CharactersRepository(jsonPlaceholderService: networkService,
											  decoderServise: decoderService,
											  imageDownloadServise: imageDownloadService)

		let characterListViewController = ModulesFactory().getCharacterListModule(withRepository: repository)
		characterListViewController.view.backgroundColor = .white
		let viewController2 = UIViewController()
		viewController2.view.backgroundColor = .green
		let navigationViewController = UINavigationController(rootViewController: characterListViewController)
		let navigationViewController2 = UINavigationController(rootViewController: viewController2)
		let tabBarController = UITabBarController()
		tabBarController.viewControllers = [navigationViewController, navigationViewController2]

		window = UIWindow(frame: UIScreen.main.bounds)
		window?.rootViewController = tabBarController
		window?.makeKeyAndVisible()

		return true
	}
}
