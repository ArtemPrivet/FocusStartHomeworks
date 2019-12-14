//
//  AuthorDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 06/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class AuthorDetailsPresenter
{
	private var authorDetailsRouter: IAuthorDetailsRouter
	private var repository: IRepository
	weak var authorDetailsView: IAuthorDetailsView?

	private var author: Author
	private var authorImageData: Data?
	private var comicsDataWrappers: [ComicsDataWrapper] = []
	private var comics: [ComicViewItem] = []

	private let dispatchGroup = DispatchGroup()
	private let dispatchQueue = DispatchQueue(label: "loadImages", qos: .userInteractive)

	init(authorDetailsRouter: IAuthorDetailsRouter, repository: IRepository, author: Author) {
		self.authorDetailsRouter = authorDetailsRouter
		self.repository = repository
		self.author = author
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

extension AuthorDetailsPresenter: IAuthorDetailsPresenter
{
	func loadData() {
		self.dispatchQueue.async {
			self.loadAuthorImage()
			self.loadComicsImages()
			self.dispatchGroup.notify(queue: .main) {
				self.authorDetailsView?.showData(withImageData: self.authorImageData, withComicsCount: self.comics.count)
			}
		}
	}

	func getAuthorName() -> String? {
		return self.author.fullName
	}

	func getComic(at index: Int) -> Comic? {
		return self.comicsDataWrappers[index].data?.results?.first
	}

	func getComicsCount() -> Int {
		return self.comics.count
	}

	func getComicTitle(at index: Int) -> String? {
		return self.comicsDataWrappers[index].data?.results?.first?.title
	}

	func getComicImage(at index: Int) -> Data? {
		return self.comics[index].imageData
	}

	func pressOnCell(withComic comic: Comic) {
		self.authorDetailsRouter.pushModuleWithComicInfo(comic: comic)
	}
}

extension AuthorDetailsPresenter
{
	private func loadAuthorImage() {
		if let path = self.author.thumbnail?.path, let thumbnailExtension = self.author.thumbnail?.thumbnailExtension
		{
			let urlString = path + ImageSize.portrait + thumbnailExtension
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: urlString) { [weak self] dataOptionalResult in
				guard let self = self else { return }
				switch dataOptionalResult {
				case .success(let data):
					self.authorImageData = data
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
		self.author.comics?.items?.forEach { comic in
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
