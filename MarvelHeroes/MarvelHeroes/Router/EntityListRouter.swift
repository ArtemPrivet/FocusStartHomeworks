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
	func inject(view: UIViewController)
	func routeToDetails(entity: IEntity?)
}

final class EntityListRouter
{
	private let moduleFactory: ModuleFactory
	private let entityType: EntityType
	private weak var view: UIViewController?

	init(moduleFactory: ModuleFactory, with entityType: EntityType) {
		self.moduleFactory = moduleFactory
		self.entityType = entityType
	}
}

extension EntityListRouter: IEntityListRouter
{
	func inject(view: UIViewController) {
		self.view = view
	}

	func routeToDetails(entity: IEntity?) {
		if let currentEntity = entity {
			let detailsViewController = moduleFactory.createEntityDetails(entity: currentEntity, with: entityType)
			view?.navigationController?.pushViewController(detailsViewController, animated: true)
		}
	}
}
