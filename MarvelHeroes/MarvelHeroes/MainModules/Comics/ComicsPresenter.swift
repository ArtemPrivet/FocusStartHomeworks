//
//  ComicsPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class ComicsPresenter
{
	private var comicsRouter: IComicsRouter
	private var repository: IRepository
	weak var comicsView: IComicsView?

	init(comicsRouter: IComicsRouter, repository: IRepository) {
		self.comicsRouter = comicsRouter
		self.repository = repository
	}

	private var comicsDataWrapper: ComicsDataWrapper?
	private var comics: [ComicViewItem] = []
	private let dispatchGroup = DispatchGroup()
	private let dispatchQueue = DispatchQueue(label: "loadComics", qos: .userInitiated)

	final private class ComicViewItem
	{
		let imageUrl: String?
		var imageData: Data?

		init(imageUrl: String?, imageData: Data? = nil) {
			self.imageUrl = imageUrl
			self.imageData = imageData
		}
	}
}

extension ComicsPresenter: IComicsPresenter
{
	func getComics(withComicName name: String?) {
		self.dispatchQueue.async {
			self.loadComicsImages(withComicName: name)
			self.dispatchGroup.notify(queue: .main) {
				self.comicsView?.reloadData(withComicsCount: self.getComicsCount())
			}
		}
	}
	func getComicsCount() -> Int {
		return self.comicsDataWrapper?.data?.results?.count ?? 0
	}
	func getComic(at index: Int) -> Comic? {
		let comic = self.comicsDataWrapper?.data?.results?[index]
		return comic
	}
	func getComicImageData(at index: Int) -> Data? {
		return self.comics[index].imageData
	}
	func onCellPressed(comic: Comic) {
		self.comicsRouter.pushModuleWithComicInfo(comic: comic)
	}
}

private extension ComicsPresenter
{
	func loadComicsImages(withComicName name: String?) {
		self.dispatchGroup.enter()
		self.repository.getComics(withComicName: name) { [weak self] comicsResult in
			guard let self = self else { return }
			switch comicsResult {
			case .success(let comicsDataWrapper):
				self.comicsDataWrapper = comicsDataWrapper
				self.getImages()
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.dispatchGroup.leave()
		}
		self.dispatchGroup.wait()
	}

	func getImages() {
		self.comics.removeAll()
		self.comicsDataWrapper?.data?.results?.forEach { comic in
			if let path = comic.thumbnail?.path, let thumbnailExtension = comic.thumbnail?.thumbnailExtension {
				self.comics.append(ComicViewItem(imageUrl: path + ImageSize.medium + thumbnailExtension))
			}
		}
		self.comics.forEach { comic in
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: comic.imageUrl ?? "", { [weak self] dataResult in
				guard let self = self else { return }
				switch dataResult {
				case .success(let data):
					if let data = data {
						comic.imageData = data
					}
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
	}
}
