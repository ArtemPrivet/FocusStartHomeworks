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
	var comicsRouter: IComicsRouter
	var repository: IRepository
	weak var comicsView: IComicsView?

	init(comicsRouter: IComicsRouter, repository: IRepository) {
		self.comicsRouter = comicsRouter
		self.repository = repository
	}

	var comicsDataWrapper: ComicsDataWrapper?
	var imagesStringURL: [String] = []
	var imagesData: [Data] = []
	let dispatchGroup = DispatchGroup()
	let dispatchQueue = DispatchQueue(label: "loadComics", qos: .userInitiated)
}

extension ComicsPresenter: IComicsPresenter
{
	func getComics(withComicName name: String?) {
		self.dispatchQueue.async {
			print("[---Start Comics Module---]")
			self.loadComicsImages(withComicName: name)
			self.dispatchGroup.notify(queue: .main) {
				print("| 3.1) Reload")
				print("[----End Comics Module----]")
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
	func getComicImageData(at index: Int) -> Data {
		return self.imagesData[index]
	}
	func onCellPressed(comic: Comic) {
		self.comicsRouter.pushModuleWithComicInfo(comic: comic)
	}
}

extension ComicsPresenter
{
	private func loadComicsImages(withComicName name: String?) {
		self.dispatchGroup.enter()
		print("| 1.1) Loading comics.")
		self.repository.getComics(withComicName: name) { [weak self] comicsResult in
			guard let self = self else { return }
			switch comicsResult {
			case .success(let comicsDataWrapper):
				self.comicsDataWrapper = comicsDataWrapper
				print("| 1.2) Comics were loaded.")
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.imagesStringURL.removeAll()
			self.imagesData.removeAll()
			self.dispatchGroup.leave()
		}
		self.dispatchGroup.wait()
		print("| 2.1) Loading images.")
		self.comicsDataWrapper?.data?.results?.forEach { [weak self] comic in
			guard let self = self else { return }
			if let path = comic.thumbnail?.path, let thumbnailExtension = comic.thumbnail?.thumbnailExtension {
				self.imagesStringURL.append( path + ImageSize.medium + thumbnailExtension)
			}
		}
		self.imagesStringURL.forEach { [weak self] imageURLString in
			guard let self = self else { return }
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: imageURLString, { dataResult in
				switch dataResult {
				case .success(let data):
					if let data = data {
						self.imagesData.append(data)
					}
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
		self.dispatchGroup.wait()
		print("| 2.2) Images were loaded.")
	}
}
