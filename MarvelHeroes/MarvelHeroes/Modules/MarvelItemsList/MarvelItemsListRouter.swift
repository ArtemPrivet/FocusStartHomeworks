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
	func showViewController(using model: IMarvelItemDetails)
}

final class MarvelItemsListRouter
{
	private var modulesFactory: ModulesFactory
	weak var viewController: MarvelItemsTableViewController?

	init(modulesFactory: ModulesFactory, viewController: MarvelItemsTableViewController?) {
		self.modulesFactory = modulesFactory
		self.viewController = viewController
	}
}
extension MarvelItemsListRouter: IMarvelItemsRouter
{
	func showViewController(using model: IMarvelItemDetails) {
		let itemDetailsVC = modulesFactory.createItemDetailsModule(using: model, withResourceURI: nil)
		self.viewController?.navigationController?.pushViewController(itemDetailsVC, animated: true)
	}
}
