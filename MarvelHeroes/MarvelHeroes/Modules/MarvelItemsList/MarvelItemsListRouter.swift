//
//  MarvelItemsListRouter.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

protocol IMarvelItemsRouter
{
	func showViewController(using item: IMarvelItemDetails, type: MarvelItemType)
}

final class MarvelItemsListRouter
{
	private var modulesFactory: ModulesFactory
	weak var viewController: MarvelItemsTableViewController?

	init(modulesFactory: ModulesFactory) {
		self.modulesFactory = modulesFactory
	}
}
extension MarvelItemsListRouter: IMarvelItemsRouter
{
	func showViewController(using item: IMarvelItemDetails, type: MarvelItemType) {
		let itemDetailsVC = modulesFactory.createItemDetailsModule(using: item, type: type)
		self.viewController?.navigationController?.pushViewController(itemDetailsVC, animated: true)
	}
}
