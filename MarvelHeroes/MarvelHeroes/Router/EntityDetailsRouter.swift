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
	func inject(viewController: UIViewController)
	func routeToAccessory(accessory: IEntity?)
	func showAlert(with text: String)
}

final class EntityDetailsRouter
{
	private weak var viewController: UIViewController?
	private let entityType: EntityType
	private var moduleFactory: ModuleFactory

	init(moduleFactory: ModuleFactory, with entityType: EntityType) {
		self.moduleFactory = moduleFactory
		self.entityType = entityType
	}
}

extension EntityDetailsRouter: IEntityDetailsRouter
{
	//Переход к дочерней сущности
	func routeToAccessory(accessory: IEntity?) {
		if let currentAccessory = accessory {
			var detailsViewController: UIViewController
			switch entityType {
			case .character, .author:
				detailsViewController = moduleFactory.createEntityDetails(entity: currentAccessory, with: .comics)
			case .comics:
				detailsViewController = moduleFactory.createEntityDetails(entity: currentAccessory, with: .author)
			}
			viewController?.navigationController?.pushViewController(detailsViewController, animated: true)
		}
	}

	func inject(viewController: UIViewController) {
		self.viewController = viewController
	}

	//Сообщение об ошибке
	func showAlert(with text: String) {
		if let vc = viewController {
			Alert.simpleAlert.showAlert(with: text, title: "Error", buttonText: "Ok", viewController: vc)
		}
	}
}
