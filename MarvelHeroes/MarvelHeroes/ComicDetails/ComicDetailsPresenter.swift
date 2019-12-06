//
//  ComicDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 05/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class ComicDetailsPresenter
{
	var comicDetailsRouter: IComicDetailsRouter
	var repository: IRepository
	weak var comicDetailsView: IComicDetailsView?

	var comic: Comic
	var comicImageData: Data?
	var authorsDataWrappers: [AuthorsDataWrapper] = []
	var authorsImagesData: [Data?] = []

	let dispatchGroup = DispatchGroup()
	let dispatchQueue = DispatchQueue(label: "loadImages", qos: .userInteractive)

	init(comicDetailsRouter: IComicDetailsRouter, repository: IRepository, comic: Comic) {
		self.comicDetailsRouter = comicDetailsRouter
		self.repository = repository
		self.comic = comic
	}
}

extension ComicDetailsPresenter: IComicDetailsPresenter
{
	func loadData() {
		self.dispatchQueue.async {
			print("[---Start Details Module---]")
			self.loadComicImage()
			self.loadAuthorsImages()
			self.dispatchGroup.notify(queue: .main) {
				print("| 4.1) showData")
				print("[----End Details Module----]")
				self.comicDetailsView?.showData(withImageData: self.comicImageData, withAuthorsCount: self.authorsImagesData.count)
			}
		}
	}

	func getComicTitle() -> String? {
		return self.comic.title
	}

	func getComicDescription() -> String? {
		return self.comic.comicDescription
	}

	func getAuthor(at index: Int) -> Author? {
		return self.authorsDataWrappers[index].data?.results?.first
	}

	func getAuthorsCount() -> Int {
		return self.authorsImagesData.count
	}

	func getAuthorName(at index: Int) -> String? {
		return self.authorsDataWrappers[index].data?.results?.first?.fullName
	}

	func getAuthorImage(at index: Int) -> Data? {
		return self.authorsImagesData[index]
	}

	func pressOnCell(withAuthor author: Author) {
		self.comicDetailsRouter.pushModuleWithAuthorInfo(author: author)
	}
}

extension ComicDetailsPresenter
{
	private func loadComicImage() {
		print("| 1.1) Loading comic's image.")
		if let path = self.comic.thumbnail?.path, let thumbnailExtension = self.comic.thumbnail?.thumbnailExtension
		{
			let urlString = path + ImageSize.portrait + thumbnailExtension
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: urlString) { [weak self] dataOptionalResult in
				guard let self = self else { return }
				switch dataOptionalResult {
				case .success(let data):
					self.comicImageData = data
					print("| 1.2) Comic's image was loaded.")
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			}
		}
	}

	private func loadAuthorsImages() {
		self.authorsDataWrappers.removeAll()
		print("| 2.1) Loading authors.")
		self.comic.creators?.items?.forEach { [weak self] author in
			guard let self = self else { return }
			self.dispatchGroup.enter()
			self.repository.getAuthor(withUrlString: author.resourceURI, { authorResult in
				switch authorResult {
				case .success(let authorDataWrapper):
					self.authorsDataWrappers.append(authorDataWrapper)
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()
		print("| 2.2) Authors were loaded.")

		self.authorsImagesData.removeAll()
		print("| 3.1) Loading authors' images.")
		self.authorsDataWrappers.forEach { authorDataWrapper in
			let thumbnail = authorDataWrapper.data?.results?.first?.thumbnail
			if let imagePath = thumbnail?.path, let imageExtension = thumbnail?.thumbnailExtension {
				let imageUrlString = imagePath + ImageSize.portraitSmall + imageExtension
				self.dispatchGroup.enter()
				self.repository.getImage(urlString: imageUrlString, { [weak self] dataOptionalResult in
					guard let self = self else { return }
					switch dataOptionalResult {
					case .success(let data):
						self.authorsImagesData.append(data)
					case .failure(let error):
						assertionFailure(error.localizedDescription)
					}
					self.dispatchGroup.leave()
				})
			}
		}
		self.dispatchGroup.wait()
		print("| 3.2) Authors' images were loaded.")
	}
}
