//
//  ComicsPresenter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IComicsPresenter
{
	func getComicsCount() -> Int
	func getComics(index: Int) -> Comic
	func getComicsImage(index: Int)
	func showDetailComics(index: Int)
	func setupView(with search: String?)
}

final class ComicsPresenter
{

	weak var comicsView: ComicsViewController?
	private let repository: IComicsRepository
	private let router: IComicsRouter
	private var comicses: [Comic] = []
	private let loadComicsQueue = DispatchQueue(label: "loadComicsQueue",
												qos: .userInteractive,
												attributes: .concurrent)

	init(repository: IComicsRepository & IDataRepository, router: IComicsRouter) {
		self.repository = repository
		self.router = router
		setupView(with: nil)
	}
}

extension ComicsPresenter: IComicsPresenter
{
	func getComicsCount() -> Int {
		return comicses.count
	}

	func getComics(index: Int) -> Comic {
		return comicses[index]
	}

	func showDetailComics(index: Int) {
		router.showDetails(comics: comicses[index])
	}

	func setupView(with search: String?) {
		loadComicsQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.loadComics(fromPastScreen: .none, with: nil, searchResult: search, { [weak self] comicsResult in
				guard let self = self else { return }
				switch comicsResult {
				case .success(let loadedData):
					self.comicses = loadedData.data.results
					DispatchQueue.main.async {
						self.comicsView?.updateData()
						self.comicsView?.stopActivityIndicator()
						self.comicsView?.checkRequestResult(isEmpty: loadedData.data.results.isEmpty)
					}
				case .failure(let error):
					DispatchQueue.main.async {
						self.comicsView?.stopActivityIndicator()
						self.comicsView?.showAlert(error: error)
					}
				}
			})
		}
	}

	func getComicsImage(index: Int) {
		loadComicsQueue.async { [weak self] in
			guard let self = self else { return }
			let comics = self.comicses[index]
			self.repository.loadImage(urlString:
				String.getUrlString(image: comics.thumbnail, variant: ThumbnailVarians.standardMedium))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						self.comicsView?.updateTableViewCell(index: index, image: image)
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
}
