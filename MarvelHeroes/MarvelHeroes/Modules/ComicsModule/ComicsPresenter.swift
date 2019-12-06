//
//  ComicsPresenter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

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
	var repository: Repository
	var router: IComicsRouter
	let loadComicsQueue = DispatchQueue(label: "loadComicsQueue", qos: .userInteractive, attributes: .concurrent)
	private var comicses: [Comic] = []

	init(repository: Repository, router: IComicsRouter) {
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
			self.repository.loadComics(fromPastScreen: nil, with: nil, searchResult: search, { [weak self] comicsResult in
				guard let self = self else { return }
				switch comicsResult {
				case .success(let loadedData):
					self.comicses = loadedData.data.results
					DispatchQueue.main.async {
						self.comicsView?.updateData()
						self.comicsView?.activityIndicator.stopAnimating()
						self.comicsView?.checkRequestResult(isEmpty: loadedData.data.results.isEmpty)
					}
				case .failure(let error):
					DispatchQueue.main.async {
						self.comicsView?.activityIndicator.stopAnimating()
					}
					print(error.localizedDescription)
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
						guard let cell = self.comicsView?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
						cell.imageView?.image = image
						cell.layoutSubviews()
						cell.imageView?.clipsToBounds = true
						guard let imageView = cell.imageView else { return }
						cell.imageView?.layer.cornerRadius = imageView.bounds.width / 2
					}
				case .failure(let error):
					print(error.localizedDescription)
				}
			}
		}
	}
}
