//
//  HeroeDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 03/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class HeroeDetailsPresenter
{
	private var heroeDetailsRouter: IHeroeDetailsRouter
	private var repository: IRepository
	weak var heroeDetailsView: IHeroeDetailsView?

	private var heroe: Heroe
	private var heroeImageData: Data?
	private var comicsDataWrappers: [ComicsDataWrapper] = []
	private var comics: [ComicViewItem] = []

	private let dispatchGroup = DispatchGroup()
	private let dispatchQueue = DispatchQueue(label: "loadImages", qos: .userInteractive)

	init(heroeDetailsRouter: IHeroeDetailsRouter, repository: IRepository, heroe: Heroe) {
		self.heroeDetailsRouter = heroeDetailsRouter
		self.repository = repository
		self.heroe = heroe
	}

	final private class ComicViewItem
	{
		let title: String?
		let imageUrl: String?
		var imageData: Data?

		init(title: String?, imageUrl: String?, imageData: Data? = nil) {
			self.title = title
			self.imageUrl = imageUrl
			self.imageData = imageData
		}
	}
}

extension HeroeDetailsPresenter: IHeroeDetailsPresenter
{
	func loadData() {
		self.dispatchQueue.async {
			self.loadHeroeImage()
			self.loadComicsImages()
			self.dispatchGroup.notify(queue: .main) {
				self.heroeDetailsView?.showData(withImageData: self.heroeImageData, withComicsCount: self.comics.count)
			}
		}
	}

	func getHeroeName() -> String? {
		return self.heroe.name
	}

	func getHeroeDescription() -> String? {
		return self.heroe.resultDescription
	}

	func getComicsCount() -> Int {
		return self.comics.count
	}

	func getComic(at index: Int) -> Comic? {
		return self.comicsDataWrappers[index].data?.results?.first
	}

	func getComicTitle(at index: Int) -> String? {
		return self.comicsDataWrappers[index].data?.results?.first?.title
	}

	func getComicImage(at index: Int) -> Data? {
		return self.comics[index].imageData
	}

	func pressOnCell(withComic comic: Comic) {
		self.heroeDetailsRouter.pushModuleWithComicInfo(comic: comic)
	}
}

extension HeroeDetailsPresenter
{
	private func loadHeroeImage() {
		if let path = self.heroe.thumbnail?.path, let thumbnailExtension = self.heroe.thumbnail?.thumbnailExtension
		{
			let urlString = path + ImageSize.portrait + thumbnailExtension
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: urlString) { [weak self] dataOptionalResult in
				guard let self = self else { return }
				switch dataOptionalResult {
				case .success(let data):
					self.heroeImageData = data
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			}
		}
	}

	private func loadComicsImages() {
		self.comicsDataWrappers.removeAll()
		self.comics.removeAll()
		self.heroe.comics?.items?.forEach { comic in
			self.dispatchGroup.enter()
			self.repository.getComic(withUrlString: comic.resourceURI, { [weak self] comicResult in
				guard let self = self else { return }
				switch comicResult {
				case .success(let comicDataWrapper):
					self.comicsDataWrappers.append(comicDataWrapper)
					let thumbnail = comicDataWrapper.data?.results?.first?.thumbnail
					let title = comicDataWrapper.data?.results?.first?.title
					if let imagePath = thumbnail?.path, let imageExtension = thumbnail?.thumbnailExtension {
						self.comics.append(ComicViewItem(title: title,
														 imageUrl: imagePath + ImageSize.portraitSmall + imageExtension))
					}
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()

		self.comics.forEach { comic in
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: comic.imageUrl ?? "", { [weak self] dataOptionalResult in
				guard let self = self else { return }
				switch dataOptionalResult {
				case .success(let data):
					comic.imageData = data
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()
	}
}
