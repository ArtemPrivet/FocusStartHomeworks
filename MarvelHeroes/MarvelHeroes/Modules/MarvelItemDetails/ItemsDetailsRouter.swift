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
	func showViewController(item: IMarvelItemDetails, type: MarvelItemType, isModallyPresented: Bool)
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
	func showViewController(item: IMarvelItemDetails, type: MarvelItemType, isModallyPresented: Bool) {
		let nextItemDetailsVC = modulesFactory.createItemDetailsModule(using: item, type: type)
		if isModallyPresented == false {
			let navController = UINavigationController(rootViewController: nextItemDetailsVC)
			viewController?.present(navController, animated: true)
		}
		else {
			viewController?.navigationController?.pushViewController(nextItemDetailsVC, animated: true)
		}
	}
}
