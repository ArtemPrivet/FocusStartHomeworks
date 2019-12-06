//
//  ItemDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.

import UIKit

protocol IDetailItemPresentable
{
	func getItem() -> IMarvelItemDetails
	func getSubItemsCount() -> Int
	func getSubItem(index: Int) -> SubItem
	func getImageURLFor(cell: DetailItemCollectionViewCell, index: Int)
	func setImageFor(cell: DetailItemCollectionViewCell, url: URL, index: Int)
	func setHeaderImage()
	func onPressed(index: Int)
	func changeItem(index: Int)
}

final class ItemDetailsPresenter
{
	private let repository: IRepository
	private var item: IMarvelItemDetails
	private var subItems: [SubItem] { item.subItemsCollection?.items ?? [] }

	weak var detailVC: ItemDetailsCollectionViewController?

	init(item: IMarvelItemDetails,
		 repository: IRepository) {
		self.item = item
		self.repository = repository
	}
}

extension ItemDetailsPresenter: IDetailItemPresentable
{
	func changeItem(index: Int) {
		 let uri = subItems[index].resourceURI
		repository.remoteDataSource.fetchMarvelItem(resourceLink: uri)
		{ [weak self] (result: Result<SubItemResponse, NetworkServiceError>) in
			switch result {
			case .success(let subItemResponse):
				guard let subItem = subItemResponse.data.results.first else { return }
				if subItem.fullName == nil {
					let comics = Comics(title: subItem.title,
										description: subItem.description,
										resourceURI: uri,
										thumbnail: subItem.thumbnail,
										creators: subItem.creators)
					self?.item = comics
				}
				else {
					// it's author
					let author = Author(fullName: subItem.fullName,
										thumbnail: subItem.thumbnail,
										resourceURI: uri, comics: subItem.comics)
					self?.item = author
				}
				self?.detailVC?.collectionView.reloadSections([0])
				self?.detailVC?.animateChangeItemTransition(reversed: true)
			case .failure: break
			}
		}
	}

	func onPressed(index: Int) {
		changeItem(index: index)
	}

	func getItem() -> IMarvelItemDetails { item }
	func getSubItemsCount() -> Int { subItems.count }
	func getSubItem(index: Int) -> SubItem { subItems[index] }

	func setImageFor(cell: DetailItemCollectionViewCell, url: URL, index: Int) {
		repository.remoteDataSource.fetchImage(url: url) { result in
			switch result {
			case .success(let fetchedImage):
				cell.setImage(fetchedImage)
			case .failure: break
			}
		}
	}

	func getImageURLFor(cell: DetailItemCollectionViewCell, index: Int) {
		// fetch subItem for Thumb
		guard let subItemURI = cell.resourceURI else { return }

		repository.remoteDataSource.fetchMarvelItem(resourceLink: subItemURI)
		{ [weak self] (result: Result<SubItemResponse, NetworkServiceError>) in
			switch result {
			case .success(let subItemResponse):
				guard let thumb = subItemResponse.data.results.first?.thumbnail else { return }
				guard let url = URL(string: thumb.path + ImageType.portraitSmall + thumb.thumbnailExtension) else { return }
				if subItemURI == self?.subItems[index].resourceURI {
					self?.setImageFor(cell: cell, url: url, index: index)
				}
			case .failure: break
			}
		}
	}

	func setHeaderImage() {
		guard detailVC?.header?.imageView != nil else { return }
		let thumb = item.thumbnail
		let urlString = thumb.path + ImageType.detail + thumb.thumbnailExtension
		guard let url = URL(string: urlString) else { return }

		repository.remoteDataSource.fetchImage(url: url) { result in
			switch result {
			case .success(let fetchedImage):
				DispatchQueue.main.async { [weak self] in
					self?.detailVC?.header?.imageView.image = fetchedImage
					UIView.animate(withDuration: 1) {
						self?.detailVC?.header?.imageView.alpha = 1
					}
				}
			case .failure: break
			}
		}
	}
}
