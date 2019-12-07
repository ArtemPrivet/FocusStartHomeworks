//
//  ItemListPresenter.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 01.12.2019.
//

import UIKit

// MARK: - Protocol IItemListPresenter
protocol IItemListPresenter
{
	var itemType: ItemType { get }
	var tableViewViewModels: [IItemViewModel] { get }

	func performLoadItems(after time: TimeInterval, with string: String)
	func onThumbnailUpdate(by thumbnail: Thumbnail,
						   aspectRatio: AspectRatio,
						   _ completion: @escaping (UIImage?) -> Void)
	func showDetail(viewModel: IItemViewModel)
}

// MARK: - Class
final class ItemListPresenter
{

	// MARK: ...Private properties
	private let repository: IItemsRepository & IImagesRepository
	private let router: IItemListRouter

	private var pendingRequesrWorkItem: DispatchWorkItem?
	private let dispatchQueueImageDownload =
		DispatchQueue(label: "com.marvelHeroes.ImageLoad",
					  qos: .userInitiated,
					  attributes: .concurrent)

	private(set) var itemType: ItemType
	private(set) var tableViewViewModels = [IItemViewModel]()

	// MARK: ...Internal properties
	weak var view: IItemListViewController?

	// MARK: ...Initialization
	init(itemType: ItemType, repository: IItemsRepository & IImagesRepository, router: IItemListRouter) {
		self.itemType = itemType
		self.repository = repository
		self.router = router
	}

	// MARK: ...Private methods
	private func perform(after: TimeInterval, _ block: @escaping () -> Void) {
		pendingRequesrWorkItem?.cancel()

		let requestWorkItem = DispatchWorkItem(block: block)

		pendingRequesrWorkItem = requestWorkItem

		DispatchQueue.main.asyncAfter(deadline: .now() + after,
									  execute: requestWorkItem)
	}

	private func fetchCharacters(with string: String) {
		self.repository.fetchCharacters(name: string) { result in
			switch result {
			case .success(let characters):
				DispatchQueue.main.async { [weak self] in
					guard characters.isEmpty == false else {
						self?.view?.showStub(with: "Nothing found on query \"\(string)\"")
						return
					}
					self?.tableViewViewModels = characters
					self?.view?.showItems()
				}
			case .failure:
				DispatchQueue.main.async { [weak self] in
					self?.view?.showStub(with: "Nothing found on query \"\(string)\"")
				}
			}
		}
	}

	private func fetchComics(with string: String) {
		self.repository.fetchComics(title: string) { result in
			switch result {
			case .success(let characters):
				DispatchQueue.main.async { [weak self] in
					guard characters.isEmpty == false else {
						self?.view?.showStub(with: "Nothing found on query \"\(string)\"")
						return
					}
					self?.tableViewViewModels = characters
					self?.view?.showItems()
				}
			case .failure:
				DispatchQueue.main.async { [weak self] in
					self?.view?.showStub(with: "Nothing found on query \"\(string)\"")
				}
			}
		}
	}

	private func fetchCreators(with string: String) {
		self.repository.fetchCreators(lastName: string) { result in
			switch result {
			case .success(let characters):
				DispatchQueue.main.async { [weak self] in
					guard characters.isEmpty == false else {
						self?.view?.showStub(with: "Nothing found on query \"\(string)\"")
						return
					}
					self?.tableViewViewModels = characters
					self?.view?.showItems()
				}
			case .failure:
				DispatchQueue.main.async { [weak self] in
					self?.view?.showStub(with: "Nothing found on query \"\(string)\"")
				}
			}
		}
	}
}

// MARK: - IItemListPresenter
extension ItemListPresenter: IItemListPresenter
{
	func performLoadItems(after time: TimeInterval, with string: String) {

		guard string.count > 0 else {
			view?.showStub(with: "Start typing text")
			return
		}
		guard string.count > 1 else {
			view?.showStub(with: "Nothing found on query \"\(string)\"")
			return
		}

		perform(after: time) { [weak self] in
			guard let self = self else { return }
			switch self.itemType {
			case .charactor: self.fetchCharacters(with: string)
			case .comic: self.fetchComics(with: string)
			case .creator: self.fetchCreators(with: string)
			}
		}
	}

	func onThumbnailUpdate(by thumbnail: Thumbnail,
						   aspectRatio: AspectRatio = .standard(.small),
						   _ completion: @escaping (UIImage?) -> Void) {

		dispatchQueueImageDownload.async { [weak self] in
			self?.repository.fetchImage(
			fromURL: thumbnail.url(withAspectRatio: aspectRatio)) { result in

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
