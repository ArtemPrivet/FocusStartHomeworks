//
//  ItemListRouter.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

// MARK: - Protocol IItemListRouter
protocol IItemListRouter
{
	func showDetail(viewModel: IItemViewModel)
}

// MARK: - Class
final class ItemListRouter
{

	// MARK: ...Private properties
	private let factory: ModulesFactory

	// MARK: ...Internal properties
	weak var view: IItemListViewController?

	// MARK: ...Initialization
	init(factory: ModulesFactory) {
		self.factory = factory
	}
}

// MARK: - IItemListRouter
extension ItemListRouter: IItemListRouter
{
	func showDetail(viewModel: IItemViewModel) {
		let apiService = MarvelAPIService()
		let decoderService = DecoderService()
		let imageDowndoalService = ImageDownloadService()
		let repository = ItemsRepository(jsonPlaceholderService: apiService,
											  decoderServise: decoderService,
											  imageDownloadServise: imageDowndoalService)
		let viewController = factory.getDetailItemModule(
			viewModel: viewModel,
			repository: repository)

		view?.navController?.pushViewController(viewController, animated: true)
	}
}
