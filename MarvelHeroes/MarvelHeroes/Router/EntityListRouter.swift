//
//  EntityListRouter.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import UIKit

protocol IEntityListRouter
{
	func inject(viewController: UIViewController)
	func routeToDetails(entity: IEntity?)
	func showAlert(with text: String)
}

final class EntityListRouter
{
	private let moduleFactory: ModuleFactory
	private let entityType: EntityType
	private weak var viewController: UIViewController?

	init(moduleFactory: ModuleFactory, with entityType: EntityType) {
		self.moduleFactory = moduleFactory
		self.entityType = entityType
	}
}

extension EntityListRouter: IEntityListRouter
{
	func inject(viewController: UIViewController) {
		self.viewController = viewController
	}
	//Переход к деталям
	func routeToDetails(entity: IEntity?) {
		if let currentEntity = entity {
			let detailsViewController = moduleFactory.createEntityDetails(entity: currentEntity, with: entityType)
			viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
		}
	}
	//Сообщение об ошибке
	func showAlert(with text: String) {
		if let vc = viewController {
			Alert.simpleAlert.showAlert(with: text, title: "Error", buttonText: "Ok", viewController: vc)
		}
	}
}
