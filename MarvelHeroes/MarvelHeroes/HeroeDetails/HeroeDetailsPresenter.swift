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
	var heroeDetailsRouter: IHeroeDetailsRouter
	var repository: IRepository
	weak var heroeDetailsView: IHeroeDetailsView?

	var heroe: Heroe
	var heroeImageData: Data?
	var comicsDataWrappers: [ComicsDataWrapper] = []
	var comicsImagesData: [Data?] = []

	let dispatchGroup = DispatchGroup()
	let dispatchQueue = DispatchQueue(label: "loadImages", qos: .userInteractive)

	init(heroeDetailsRouter: IHeroeDetailsRouter, repository: IRepository, heroe: Heroe) {
		self.heroeDetailsRouter = heroeDetailsRouter
		self.repository = repository
		self.heroe = heroe
	}
}

extension HeroeDetailsPresenter: IHeroeDetailsPresenter
{
	func loadData() {
		self.dispatchQueue.async {
			print("[---Start Details Module---]")
			self.loadHeroeImage()
			self.loadComicsImages()
			self.dispatchGroup.notify(queue: .main) {
				print("| 4.1) showData")
				print("[----End Details Module----]")
				self.heroeDetailsView?.showData(withImageData: self.heroeImageData, withComicsCount: self.comicsImagesData.count)
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
		return self.comicsImagesData.count
	}

	func getComic(at index: Int) -> Comic? {
		return self.comicsDataWrappers[index].data?.results?.first
	}

	func getComicTitle(at index: Int) -> String? {
		return self.comicsDataWrappers[index].data?.results?.first?.title
	}

	func getComicImage(at index: Int) -> Data? {
		return self.comicsImagesData[index]
	}

	func pressOnCell(withComic comic: Comic) {
		self.heroeDetailsRouter.pushModuleWithComicInfo(comic: comic)
	}
}

extension HeroeDetailsPresenter
{
	private func loadHeroeImage() {
		print("| 1.1) Loading heroe's image.")
		if let path = self.heroe.thumbnail?.path, let thumbnailExtension = self.heroe.thumbnail?.thumbnailExtension
		{
			let urlString = path + ImageSize.portrait + thumbnailExtension
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: urlString) { [weak self] dataOptionalResult in
				guard let self = self else { return }
				switch dataOptionalResult {
				case .success(let data):
					self.heroeImageData = data
					print("| 1.2) Heroe's image was loaded.")
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			}
		}
	}

	private func loadComicsImages() {
		self.comicsDataWrappers.removeAll()
		print("| 2.1) Loading comics.")
		self.heroe.comics?.items?.forEach { [weak self] comic in
			guard let self = self else { return }
			self.dispatchGroup.enter()
			self.repository.getComic(withUrlString: comic.resourceURI, { comicResult in
				switch comicResult {
				case .success(let comicDataWrapper):
					self.comicsDataWrappers.append(comicDataWrapper)
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()
		print("| 2.2) Comics were loaded.")

		self.comicsImagesData.removeAll()
		print("| 3.1) Loading comics' images.")
		self.comicsDataWrappers.forEach { comicDataWrapper in
			let thumbnail = comicDataWrapper.data?.results?.first?.thumbnail
			if let imagePath = thumbnail?.path, let imageExtension = thumbnail?.thumbnailExtension {
				let imageUrlString = imagePath + ImageSize.portraitSmall + imageExtension
				self.dispatchGroup.enter()
				self.repository.getImage(urlString: imageUrlString, { [weak self] dataOptionalResult in
					guard let self = self else { return }
					switch dataOptionalResult {
					case .success(let data):
						self.comicsImagesData.append(data)
					case .failure(let error):
						assertionFailure(error.localizedDescription)
					}
					self.dispatchGroup.leave()
				})
			}
		}
		self.dispatchGroup.wait()
		print("| 3.2) Comics' images were loaded.")
	}
}
