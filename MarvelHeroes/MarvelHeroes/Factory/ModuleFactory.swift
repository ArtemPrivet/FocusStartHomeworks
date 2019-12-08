//
//  ModuleFactory.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//
import UIKit

struct ModuleFactory
{
	private let repository: Repository

	init() {
		repository = Repository()
	}

	func createTabBarViewController() -> UIViewController {
		let heroesListController = createList(with: .character)
		let heroesNavigationController = createNavigationBarController(with: heroesListController)
		heroesListController.navigationItem.title = "🦸‍♂️Heroes"

		let comicsListController = createList(with: .comics)
		let comicsNavigationController = createNavigationBarController(with: comicsListController)

		let authorsListController = createList(with: .author)
		let authorsNavigationController = createNavigationBarController(with: authorsListController)

		let controllers = [heroesNavigationController, comicsNavigationController, authorsNavigationController]
		let tabBarController = UITabBarController()
		for controller in controllers {
			if let title = controller.title, let imageName = InterfaceConstants.tabBarItemImages[title] {
				let item = UITabBarItem(title: controller.title,
										image: UIImage(named: imageName),
										selectedImage: UIImage(named: imageName))
				controller.tabBarItem = item
			}
		}
		tabBarController.viewControllers = controllers

		return tabBarController
	}

	private func createNavigationBarController(with rootController: UIViewController) -> UIViewController {
		let navigationController = UINavigationController(rootViewController: rootController)
		navigationController.navigationBar.prefersLargeTitles = true
		return  navigationController
	}
	//Создание модуля списка
	func createList(with entityType: EntityType) -> UIViewController {
		let viewController = ListViewController()
		let presenter = EntityListPresenter(with: entityType)
		let router = EntityListRouter(moduleFactory: self, with: entityType)
		let view = ListView(presenter: presenter, repository: repository)
		presenter.inject(router: router, repository: repository, view: view)
		router.inject(viewController: viewController)
		viewController.inject(presenter: presenter)
		viewController.view = view
		return viewController
	}
	//Создание модуля деталей
	func createEntityDetails(entity: IEntity, with entityType: EntityType) -> UIViewController {
		let viewController = DetailsViewController()
		let presenter = EntityDetailsPresenter(entity: entity, with: entityType)
		let router = EntityDetailsRouter(moduleFactory: self, with: entityType)
		let view = DetailsView(presenter: presenter, repository: repository)
		presenter.inject(router: router, repository: repository, view: view)
		router.inject(viewController: viewController)
		viewController.inject(presenter: presenter)
		viewController.view = view
		return viewController
	}
}
