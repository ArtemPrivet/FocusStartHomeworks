//
//  EntityDetailsRouter.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import UIKit

protocol IEntityDetailsRouter: AnyObject
{
	func inject(view: UIViewController)
	func routeToAccessory(accessory: IEntity?)
}

final class EntityDetailsRouter
{
	private weak var view: UIViewController?
	private let entityType: EntityType
	private var moduleFactory: ModuleFactory

	init(moduleFactory: ModuleFactory, with entityType: EntityType) {
		self.moduleFactory = moduleFactory
		self.entityType = entityType
	}
}

extension EntityDetailsRouter: IEntityDetailsRouter
{
	func routeToAccessory(accessory: IEntity?) {
		if let currentAccessory = accessory {
			var detailsViewController: UIViewController
			switch entityType {
			case .character, .author:
				detailsViewController = moduleFactory.createEntityDetails(entity: currentAccessory, with: .comics)
			case .comics:
				detailsViewController = moduleFactory.createEntityDetails(entity: currentAccessory, with: .author)
			}
			view?.navigationController?.pushViewController(detailsViewController, animated: true)
		}
	}

	func inject(view: UIViewController) {
		self.view = view
	}
}
