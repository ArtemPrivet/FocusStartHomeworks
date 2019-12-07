//
//  ItemsDetailsRouter.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 06.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IMarvelDetailsItemsRouter
{
	func showViewController(item: IMarvelItemDetails, type: MarvelItemType)
}

final class ItemsDetailsRouter
{
	private var modulesFactory: ModulesFactory
	weak var viewController: ItemDetailsCollectionViewController?

	init(modulesFactory: ModulesFactory, viewController: ItemDetailsCollectionViewController?) {
		self.modulesFactory = modulesFactory
		self.viewController = viewController
	}
}
extension ItemsDetailsRouter: IMarvelDetailsItemsRouter
{
	func showViewController(item: IMarvelItemDetails, type: MarvelItemType) {
		let nextItemDetailsVC = modulesFactory.createItemDetailsModule(using: item, type: type)
		let navController = UINavigationController(rootViewController: nextItemDetailsVC)
		navController.restorationIdentifier = ModulesFactory.secondaryId
		if viewController?.navigationController?.restorationIdentifier == ModulesFactory.primaryId {
			viewController?.present(navController, animated: true)
		}
		else {
			viewController?.navigationController?.pushViewController(nextItemDetailsVC, animated: true)
		}
	}
}
