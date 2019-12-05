//
//  AuthorsPresenter.swift
//  MarvelHeroes
//
//  Created by Kirill Fedorov on 05.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import UIKit

protocol IAuthorsPresenter
{
	func getAuthorsCount() -> Int
	func getAuthor(index: Int) -> Creator
	func getAuthorImage(index: Int)
	func showDetailAuthor(index: Int)
	func setupView(with search: String?)
}

final class AuthorsPresenter
{

	weak var authorView: AuthorsViewController?
	var repository: Repository
	var router: IAuthorRouter
	let serialQueue = DispatchQueue(label: "loadAuthorsQueue", qos: .userInteractive)
	private var authors: [Creator] = []

	init(repository: Repository, router: IAuthorRouter) {
		self.repository = repository
		self.router = router
		setupView(with: nil)
	}
}

extension AuthorsPresenter: IAuthorsPresenter
{

	func getAuthorsCount() -> Int {
		return authors.count
	}

	func getAuthor(index: Int) -> Creator {
		return authors[index]
	}

	func showDetailAuthor(index: Int) {
		router.showDetails(author: authors[index])
	}

	func setupView(with search: String?) {
		serialQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.loadAuthors(with: nil, searchResult: search, { [weak self] authorsResult in
				guard let self = self else { return }
				switch authorsResult {
				case .success(let loadedData):
					self.authors = loadedData.data.results
					DispatchQueue.main.async {
						self.authorView?.updateData()
						self.authorView?.activityIndicator.stopAnimating()
						self.authorView?.checkRequestResult(isEmpty: loadedData.data.results.isEmpty)
					}
				case .failure(let error):
					DispatchQueue.main.async {
						self.authorView?.activityIndicator.stopAnimating()
					}
					print(error.localizedDescription)
				}
			})
		}
	}

	func getAuthorImage(index: Int) {
		serialQueue.async { [weak self] in
			guard let self = self else { return }
			let author = self.authors[index]
			self.repository.loadImage(urlString:
				String.getUrlString(image: author.thumbnail, variant: ThumbnailVarians.standardMedium))
			{ imageResult in
				switch imageResult {
				case .success(let image):
					DispatchQueue.main.async {
						guard let cell = self.authorView?.tableView.cellForRow(at: IndexPath(row: index, section: 0)) else { return }
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
