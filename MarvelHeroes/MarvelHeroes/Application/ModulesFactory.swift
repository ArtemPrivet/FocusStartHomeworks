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
	private enum Titles
	{
		static let heroes = "🦸🏻‍♂️ Heroes"
		static let comics = "🗺 Comics"
		static let authors = "👨🏻‍🎨 Authors"
	}

private enum TabsTitles
	{
		static let heroes = "Heroes"
		static let comics = "Comics"
		static let authors = "Authors"
	}

	private let networkService: INetworkRequestable
	private let jsonDataFetcher: IJSONDataFetchable
	private let networkManager: IRepositoryDataSource

	init(networkService: INetworkRequestable,
		 jsonDataFetcher: IJSONDataFetchable,
		 networkManager: IRepositoryDataSource
		 ) {
		self.networkService = networkService
		self.jsonDataFetcher = jsonDataFetcher
		self.networkManager = networkManager
	}

	func createItemsListModule(with type: MarvelItemType) -> MarvelItemsTableViewController {
		let repository = MarvelItemsRepository(remoteDataSource: networkManager)
		let router = MarvelItemsListRouter(modulesFactory: self)
		let presenter = MarvelItemsListPresenter(repository: repository, router: router)
		let marvelItemsTableViewController = MarvelItemsTableViewController(
			searchController: UISearchController(),
			presenter: presenter,
			marvelItemType: type
		)
		router.viewController = marvelItemsTableViewController
		presenter.itemsList = marvelItemsTableViewController

		switch marvelItemsTableViewController.marvelItemType {
		case .heroes:
			marvelItemsTableViewController.title = Titles.heroes
			marvelItemsTableViewController.tabBarItem = UITabBarItem(
				title: TabsTitles.heroes,
				image: UIImage(named: "shield")?.withRenderingMode(.alwaysOriginal),
				tag: 0)
		case .comics:
			marvelItemsTableViewController.title = Titles.comics
			marvelItemsTableViewController.tabBarItem = UITabBarItem(
				title: TabsTitles.comics,
				image: UIImage(named: "comic")?.withRenderingMode(.alwaysOriginal),
				tag: 1)
		case .authors:
			marvelItemsTableViewController.title = Titles.authors
			marvelItemsTableViewController.tabBarItem = UITabBarItem(
				title: TabsTitles.authors,
				image: UIImage(named: "writer")?.withRenderingMode(.alwaysOriginal),
				tag: 2)
		}

		marvelItemsTableViewController.definesPresentationContext = true

		return marvelItemsTableViewController
	}

	func createItemDetailsModule(using item: IMarvelItemDetails, type: MarvelItemType)
		-> ItemDetailsCollectionViewController {
			let router = ItemsDetailsRouter(modulesFactory: self)
		let repository = MarvelItemsRepository(remoteDataSource: networkManager)
		let presenter = ItemDetailsPresenter(item: item, repository: repository, router: router)
		let detailVC = ItemDetailsCollectionViewController(
			collectionViewLayout: StretchyHeaderLayout(),
			presenter: presenter, marvelItemType: type)
			presenter.itemsDetailList = detailVC
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
			return navController
		}

		return tabBarController
	}
}
