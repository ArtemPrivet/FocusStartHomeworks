//
//  ItemDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.

import UIKit

struct MarvelSubItemPresentation
{
	let title: String
	let description: String
}

protocol IDetailItemPresentable
{
	func getItem() -> IMarvelItemDetails
	func getSubItemsCount() -> Int
	func getSubItem(index: Int) -> IMarvelItemDetails
	func setImageToCell(useIndex: Int, cell: DetailItemCollectionViewCell)
	func setHeaderImage()
	func onPressed(index: Int)
}

final class ItemDetailsPresenter
{
	private let router: ItemsDetailsRouter
	private let repository: IRepository
	private var item: IMarvelItemDetails { didSet { fetchSubItems() } }
	var itemsDetailList: IItemDetailsList?

	private var subItems = [IMarvelItemDetails]()

	init(item: IMarvelItemDetails, repository: IRepository, router: ItemsDetailsRouter) {
		self.item = Hero.empty
		self.repository = repository
		self.router = router
		self.setItem(item) // for activating didSet
	}

	private func setItem(_ item: IMarvelItemDetails) {
		self.item = item
	}

	private func fetchSubItems() {
		if item as? Hero != nil || item as? Author != nil  {
			repository.remoteDataSource.fetchMarvelItems(
				type: .comics, appendingPath: (item as? Hero != nil) ?
				MarvelItemType.heroes.rawValue : MarvelItemType.authors.rawValue,
				withId: item.id, searchText: "")
			{ [weak self] (result: Result<ComicsServerResponse, NetworkServiceError>) in
				switch result {
				case .success(let comics):
					self?.subItems = comics.data.results
					self?.itemsDetailList?.removeActivityIndicator()
					self?.itemsDetailList?.removeStubView()
					self?.itemsDetailList?.reloadSection()
				case .failure: break
				}
			}
		}
		else if item as? Comics != nil {
			repository.remoteDataSource.fetchMarvelItems(
				type: .authors, appendingPath: MarvelItemType.comics.rawValue,
				withId: item.id, searchText: "")
			{ [weak self] (result: Result<AuthorsServerResponse, NetworkServiceError>) in
				switch result {
				case .success(let authors):
					self?.subItems = authors.data.results
					self?.itemsDetailList?.removeActivityIndicator()
					self?.itemsDetailList?.removeStubView()
					self?.itemsDetailList?.reloadSection()
				case .failure: break
				}
			}
		}
}
}

extension ItemDetailsPresenter: IDetailItemPresentable
{
	func getSubItem(index: Int) -> IMarvelItemDetails { subItems[index] }
	func getItem() -> IMarvelItemDetails { item }
	func getSubItemsCount() -> Int { subItems.count }

	func setHeaderImage() {
		let thumb = item.thumbnail
		let urlString = thumb.path + ImageType.detail + thumb.thumbnailExtension
		guard let url = URL(string: urlString) else { return }

		repository.remoteDataSource.fetchImage(url: url) { result in
			switch result {
			case .success(let fetchedImage):
				DispatchQueue.main.async { [weak self] in
					self?.itemsDetailList?.setHeaderImage(image: fetchedImage)
				}
			case .failure: break
			}
		}
	}

	func setImageToCell(useIndex: Int, cell: DetailItemCollectionViewCell) {
		let thumb = subItems[useIndex].thumbnail
		guard let imageUrl = URL(string: thumb.path + ImageType.portraitSmall + thumb.thumbnailExtension) else { return }

		repository.remoteDataSource.fetchImage(url: imageUrl) { result in
			switch result {
			case .success(let fetchedImage):
				DispatchQueue.main.async {
					if imageUrl.absoluteString.hasPrefix(cell.thumbPath ?? "") {
						cell.setImage(fetchedImage)
					}
				}
			case .failure: break
			}
		}
	}

	func onPressed(index: Int) {
		var type: MarvelItemType = .heroes

		if item as? Hero != nil { type = .heroes }
		if item as? Author != nil { type = .authors }
		if item as? Comics != nil { type = .comics }

		guard let detailVC = itemsDetailList else { return }

		router.showViewController(
			item: subItems[index],
			type: type,
			isModallyPresented: detailVC.isModallyPresented)
	}
}
