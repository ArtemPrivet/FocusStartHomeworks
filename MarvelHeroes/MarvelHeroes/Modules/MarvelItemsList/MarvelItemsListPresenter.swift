//
//  MarvelItemsListPresenter.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IContentPresentable: AnyObject
{
	func itemsCount() -> Int
	func onCellPressed(useIndex: Int)
	func setImageToCell(useIndex: Int, cell: MarvelItemTableViewCell)
}

protocol IMarvelContentPresentable: IContentPresentable
{
	func getHero(ofIndex: Int) -> Hero
	func getComics(ofIndex: Int) -> Comics
	func getAuthor(ofIndex: Int) -> Author
	func searchForItems(type: MarvelItemType, with text: String?)
}

final class MarvelItemsListPresenter
{
	private let repository: IRepository
	private let router: IMarvelItemsRouter
	var itemsList: IMarvelItemsList?

	private var heroes = [Hero]()
	private var comics = [Comics]()
	private var authors = [Author]()

	init(repository: IRepository, router: IMarvelItemsRouter) {
		self.repository = repository
		self.router = router
	}

	private func fetchHeroes(type: MarvelItemType, text: String) {
		repository.remoteDataSource.fetchMarvelItems(
			type: type, appendingPath: nil, withId: nil,
			searchText: text) { [weak self] (result: Result<HeroesServerResponse, NetworkServiceError>) in
				switch result {
				case .success(let heroesResponse):
					self?.heroes = heroesResponse.data.results
					self?.updateUI(items: self?.heroes ?? [], text: text)
				case .failure(let error): self?.setTooManyRequestsStub(error: error)
				}
		}
	}

	private func fetchComics(type: MarvelItemType, text: String) {
		repository.remoteDataSource.fetchMarvelItems(
			type: type, appendingPath: nil, withId: nil,
			searchText: text) { [weak self] (result: Result<ComicsServerResponse, NetworkServiceError>) in
				switch result {
				case .success(let comicsResponse):
					self?.comics = comicsResponse.data.results
					self?.updateUI(items: self?.comics ?? [], text: text)
				case .failure(let error): self?.setTooManyRequestsStub(error: error)
				}
		}
	}

	private func fetchAuthors(type: MarvelItemType, text: String) {
		repository.remoteDataSource.fetchMarvelItems(
			type: type, appendingPath: nil, withId: nil,
			searchText: text) { [weak self] (result: Result<AuthorsServerResponse, NetworkServiceError>) in
				switch result {
				case .success(let authorsResponse):
					self?.authors = authorsResponse.data.results
					self?.updateUI(items: self?.authors ?? [], text: text)
				case .failure(let error): self?.setTooManyRequestsStub(error: error)
				}
		}
	}

	private func updateUI(items: [Decodable], text: String) {
		DispatchQueue.main.async { [weak self] in
			self?.itemsList?.reloadSection()
			if items.isEmpty {
				self?.itemsList?.setStubView(withImage: true, message: "Nothing found on query \"\(text)\"", animated: false)
			}
		}
	}

	private func setTooManyRequestsStub(error: NetworkServiceError) {
		if error.localizedDescription == NetworkServiceError.tooManyRequests.localizedDescription{
			DispatchQueue.main.async { [weak self] in
				self?.itemsList?.setStubView(withImage: true,
											 message: "You have exceeded your rate limit.  Please try again later.",
											 animated: true)
			}
		}
	}

	private func makeImageURLString(with index: Int) -> String {
		guard let itemType = itemsList?.marvelItemType else { return "" }
		var urlString = ""
		switch itemType {
		case .heroes:
			guard index < heroes.count else { return "" }
			let thumb = heroes[index].thumbnail
			urlString = thumb.path + ImageType.standartMedium + thumb.thumbnailExtension
		case .comics:
			guard index < comics.count else { return "" }
			let thumb = comics[index].thumbnail
			urlString = thumb.path + ImageType.portraitSmall + thumb.thumbnailExtension
		case .authors:
			guard index < authors.count else { return "" }
			let thumb = authors[index].thumbnail
			urlString = thumb.path + ImageType.portraitSmall + thumb.thumbnailExtension
		}
		return urlString
	}
}

extension MarvelItemsListPresenter: IContentPresentable
{
	func setImageToCell(useIndex: Int, cell: MarvelItemTableViewCell) {
		guard cell.imageView != nil else { return }
		guard let imageUrl = URL(string: makeImageURLString(with: useIndex)) else { return }

		repository.remoteDataSource.fetchImage(url: imageUrl) { result in
			switch result {
			case .success(let fetchedImage):
				DispatchQueue.main.async {
					if imageUrl.absoluteString.hasPrefix(cell.imageUrlPath ?? "") {
						cell.setImage(image: fetchedImage)
					}
				}
			case .failure: break
			}
		}
	}

	func itemsCount() -> Int {
		guard let itemType = itemsList?.marvelItemType else { return 0 }

		switch itemType {
		case .heroes:
			return heroes.count
		case .comics:
			return comics.count
		case .authors:
			return authors.count
		}
	}

	func onCellPressed(useIndex: Int) {
		guard let itemType = itemsList?.marvelItemType else { return }
		switch itemType {
		case .heroes:
			router.showViewController(using: heroes[useIndex], type: itemType)
		case .comics:
			router.showViewController(using: comics[useIndex], type: itemType)
		case .authors:
			router.showViewController(using: authors[useIndex], type: itemType)
		}
	}
}

extension MarvelItemsListPresenter: IMarvelContentPresentable
{
	func getHero(ofIndex: Int) -> Hero {
		guard ofIndex < heroes.count else { return Hero.empty }
		return heroes[ofIndex]
	}

	func getComics(ofIndex: Int) -> Comics {
		guard ofIndex < comics.count else { return Comics.empty }
		return comics[ofIndex]
	}

	func getAuthor(ofIndex: Int) -> Author {
		guard ofIndex < authors.count else { return Author.empty }
		return authors[ofIndex]
	}

	func searchForItems(type: MarvelItemType, with text: String?) {
		guard let text = text, text.isEmpty == false else {
			heroes = []
			return
		}

		guard let itemType = itemsList?.marvelItemType else { return }

		switch itemType {
		case .heroes:
			fetchHeroes(type: .heroes, text: text)
		case .comics:
			fetchComics(type: .comics, text: text)
		case .authors:
			fetchAuthors(type: .authors, text: text)
		}
	}
}
