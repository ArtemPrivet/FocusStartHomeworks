//
//  ItemRouter.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

// MARK: - Protocol IItemRouter
protocol IItemRouter
{
	func showDetail(viewModel: IItemViewModel)
}

// MARK: - Class
final class ItemRouter
{

	// MARK: ...Private properties
	private let factory: ModulesFactory

	// MARK: ...Internal properties
	weak var view: INavigationItemDetailViewController?

	// MARK: ...Initialization
	init(factory: ModulesFactory) {
		self.factory = factory
	}
}

// MARK: - IItemRouter
extension ItemRouter: IItemRouter
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

		view?.navigationController?.pushViewController(viewController, animated: true)
	}
}
