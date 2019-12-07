//
//  ModulesFactory.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 02.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

final class ModulesFactory
{
	static let primaryId = "primary"
	static let secondaryId = "secondary"

	func createItemsListModule(with type: MarvelItemType) -> MarvelItemsTableViewController {
		let repository = MarvelItemsRepository(remoteDataSource: NetworkManager())
		let router = MarvelItemsListRouter(modulesFactory: self, viewController: nil)
		let presenter = MarvelItemsListPresenter(repository: repository, router: router, heroesListVC: nil)
		let marvelItemsTableViewController = MarvelItemsTableViewController(
			searchController: UISearchController(),
			presenter: presenter,
			marvelItemType: type
		)
		router.viewController = marvelItemsTableViewController
		presenter.itemsList = marvelItemsTableViewController

		switch marvelItemsTableViewController.marvelItemType {
		case .heroes:
			marvelItemsTableViewController.title = "🦸🏻‍♂️ Heroes"
			marvelItemsTableViewController.tabBarItem = UITabBarItem(
				title: "Heroes",
				image: UIImage(named: "shield")?.withRenderingMode(.alwaysOriginal),
				tag: 0)
		case .comics:
			marvelItemsTableViewController.title = "🗺 Comics"
			marvelItemsTableViewController.tabBarItem = UITabBarItem(title: "Comics",
																	 image: UIImage(named: "comic")?.withRenderingMode(.alwaysOriginal),
																	 tag: 1)
		case .authors:
			marvelItemsTableViewController.title = "👨🏻‍🎨 Authors"
			marvelItemsTableViewController.tabBarItem = UITabBarItem(title: "Authors",
																	 image: UIImage(named: "writer")?.withRenderingMode(.alwaysOriginal),
																	 tag: 2)
		}

		marvelItemsTableViewController.definesPresentationContext = true

		return marvelItemsTableViewController
	}

	func createItemDetailsModule(using item: IMarvelItemDetails, type: MarvelItemType)
		-> ItemDetailsCollectionViewController {
		let router = ItemsDetailsRouter(modulesFactory: self, viewController: nil)
		let repository = MarvelItemsRepository(remoteDataSource: NetworkManager())
		let presenter = ItemDetailsPresenter(item: item, repository: repository, router: router)
		let detailVC = ItemDetailsCollectionViewController(
			collectionViewLayout: StretchyHeaderLayout(),
			presenter: presenter, itemType: type)
		presenter.detailVC = detailVC
		router.viewController = detailVC
		return detailVC
	}

	func createTabBarControllerModule() -> UITabBarController {
		let tabBarController = UITabBarController()
		if #available(iOS 13.0, *) {
			tabBarController.tabBar.tintColor = .systemRed
			tabBarController.tabBar.barTintColor = .systemBackground
			tabBarController.tabBar.layer.borderColor = UIColor.systemBackground.cgColor
		}
		else {
			tabBarController.tabBar.tintColor = .black
			tabBarController.tabBar.barTintColor = .white
			tabBarController.tabBar.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
		}

		tabBarController.tabBar.clipsToBounds = true
		tabBarController.tabBar.isTranslucent = false

		let comicsTableViewController = self.createItemsListModule(with: .comics)
		let authorsTableViewController = self.createItemsListModule(with: .authors)
		let heroesTableVC = self.createItemsListModule(with: .heroes)

		let controllers = [heroesTableVC, comicsTableViewController, authorsTableViewController]

		tabBarController.viewControllers = controllers.map {
			let navController = UINavigationController(rootViewController: $0)
			navController.restorationIdentifier = ModulesFactory.primaryId
			return navController
		}

		return tabBarController
	}
}
