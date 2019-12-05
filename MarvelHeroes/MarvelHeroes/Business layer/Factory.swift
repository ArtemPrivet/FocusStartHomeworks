//
//  Factory.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

final class ModulesFactory
{
	func getItemListModule(
		withRepository repository: IItemsRepository & IImagesRepository,
		itemType: ItemType) -> ItemListViewController {

		let router = ItemListRouter(factory: self)
		let presenter = ItemListPresenter(itemType: itemType,
										  repository: repository,
										  router: router)
		let viewController = ItemListViewController(presenter: presenter)
		router.view = viewController
		presenter.view = viewController

		return viewController
	}

	func getDetailItemModule(
		viewModel: IItemViewModel,
		repository: IItemsRepository & IImagesRepository) -> ItemDetailViewController {

		let router = ItemRouter(factory: self)
		let presenter = ItemPresenter(viewModel: viewModel,
									  repository: repository,
									  router: router)
		let viewController = ItemDetailViewController(presenter: presenter)
		router.view = viewController
		presenter.view = viewController

		return viewController
	}
}
