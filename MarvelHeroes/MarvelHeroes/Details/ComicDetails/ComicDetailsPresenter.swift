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
	private var comicDetailsRouter: IComicDetailsRouter
	private var repository: IRepository
	weak var comicDetailsView: IComicDetailsView?

	private var comic: Comic
	private var comicImageData: Data?
	private var authorsDataWrappers: [AuthorsDataWrapper] = []
	private var authors: [AuthorViewItem] = []

	private let dispatchGroup = DispatchGroup()
	private let dispatchQueue = DispatchQueue(label: "loadImages", qos: .userInteractive)

	init(comicDetailsRouter: IComicDetailsRouter, repository: IRepository, comic: Comic) {
		self.comicDetailsRouter = comicDetailsRouter
		self.repository = repository
		self.comic = comic
	}

	final private class AuthorViewItem
	{
		let name: String?
		let imageUrl: String?
		var imageData: Data?

		init(name: String?, imageUrl: String?, imageData: Data? = nil) {
			self.name = name
			self.imageUrl = imageUrl
			self.imageData = imageData
		}
	}
}

extension ComicDetailsPresenter: IComicDetailsPresenter
{
	func loadData() {
		self.dispatchQueue.async {
			self.loadComicImage()
			self.loadAuthorsImages()
			self.dispatchGroup.notify(queue: .main) {
				self.comicDetailsView?.showData(withImageData: self.comicImageData, withAuthorsCount: self.authors.count)
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
		return self.authors.count
	}

	func getAuthorName(at index: Int) -> String? {
		return self.authorsDataWrappers[index].data?.results?.first?.fullName
	}

	func getAuthorImage(at index: Int) -> Data? {
		return self.authors[index].imageData
	}

	func pressOnCell(withAuthor author: Author) {
		self.comicDetailsRouter.pushModuleWithAuthorInfo(author: author)
	}
}

extension ComicDetailsPresenter
{
	private func loadComicImage() {
		if let path = self.comic.thumbnail?.path, let thumbnailExtension = self.comic.thumbnail?.thumbnailExtension
		{
			let urlString = path + ImageSize.portrait + thumbnailExtension
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: urlString) { [weak self] dataOptionalResult in
				guard let self = self else { return }
				switch dataOptionalResult {
				case .success(let data):
					self.comicImageData = data
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			}
		}
	}

	private func loadAuthorsImages() {
		self.authorsDataWrappers.removeAll()
		self.authors.removeAll()
		self.comic.creators?.items?.forEach { author in
			self.dispatchGroup.enter()
			self.repository.getAuthor(withUrlString: author.resourceURI, { [weak self] authorResult in
				guard let self = self else { return }
				switch authorResult {
				case .success(let authorDataWrapper):
					self.authorsDataWrappers.append(authorDataWrapper)
					let thumbnail = authorDataWrapper.data?.results?.first?.thumbnail
					let name = authorDataWrapper.data?.results?.first?.fullName
					if let imagePath = thumbnail?.path, let imageExtension = thumbnail?.thumbnailExtension {
						self.authors.append(AuthorViewItem(name: name,
														 imageUrl: imagePath + ImageSize.portraitSmall + imageExtension))
					}
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()

		self.authors.forEach { author in
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: author.imageUrl ?? "", { [weak self] dataOptionalResult in
				guard let self = self else { return }
				switch dataOptionalResult {
				case .success(let data):
					author.imageData = data
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()
	}
}
