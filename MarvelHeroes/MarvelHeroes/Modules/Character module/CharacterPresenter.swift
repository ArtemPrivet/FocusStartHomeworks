//
//  ItemPresenter.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import UIKit

// MARK: - Protocol IItemPresenter
protocol IItemPresenter
{
	var detailViewModel: IItemViewModel { get }
	var tableViewViewModels: [IItemViewModel] { get }

	func loadItems()//(withItemId itemId: String, fromType type: ItemType)
	func onThumbnailUpdate(by path: String, extension: String?, _ completion: @escaping (UIImage?) -> Void)
	func showDetail(viewModel: IItemViewModel)
}

// MARK: - Class
final class ItemPresenter
{

	// MARK: ...Private properties
	private let repository: IItemsRepository & IImagesRepository
	private let router: IItemRouter

	private(set) var detailViewModel: IItemViewModel
	private(set) var tableViewViewModels = [IItemViewModel]()

	// MARK: ...Internal properties
	weak var view: IItemViewController?

	// MARK: ...Initialization
	init(viewModel: IItemViewModel, repository: IItemsRepository & IImagesRepository, router: IItemRouter) {
		self.detailViewModel = viewModel
		self.repository = repository
		self.router = router
	}

	// MARK: ...Private methods
	private func fetchComics(withItemId itemId: String, fromType type: ItemType) {
		repository.fetchComics(fromType: type, itemId: itemId) { [weak self] result in
			switch result {
			case .success(let comics):
				DispatchQueue.main.async {
					self?.tableViewViewModels = comics
					self?.view?.showItems()
				}
			case .failure:
				DispatchQueue.main.async {
					self?.view?.showAlert()
				}
			}
		}
	}

	private func fetchCreators(withItemId itemId: String) {
		repository.fetchCreator(comicID: itemId) { [weak self] result in
			switch result {
			case .success(let creators):
				DispatchQueue.main.async {
					self?.tableViewViewModels = creators
					self?.view?.showItems()
				}
			case .failure:
				DispatchQueue.main.async {
					self?.view?.showAlert()
				}
			}
		}
	}
}

// MARK: - IItemPresenter
extension ItemPresenter: IItemPresenter
{
	func loadItems() {
		switch detailViewModel.itemType {
		case .charactor, .creator: fetchComics(withItemId: String(detailViewModel.id),
											   fromType: detailViewModel.itemType)
		case .comic: fetchCreators(withItemId: String(detailViewModel.id))
		}
	}

	func onThumbnailUpdate(by path: String, extension: String? = nil, _ completion: @escaping (UIImage?) -> Void) {
		DispatchQueue(label: "com.marvelHeroes.ImageLoad",
					  qos: .userInitiated,
					  attributes: .concurrent).async { [weak self] in
			self?.repository.fetchImage(from: path, extension: `extension`) { result in
				switch result {
				case .success(let image):
					DispatchQueue.main.async {
						completion(image)
					}
				case .failure:
					DispatchQueue.main.async {
						completion(nil)
					}
				}
			}
		}
	}

	func showDetail(viewModel: IItemViewModel) {
		router.showDetail(viewModel: viewModel)
	}
}
