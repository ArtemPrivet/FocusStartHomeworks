//
//  DetailPresenter.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import Foundation

final class DetailPresenter
{

	private let hero: ResultChar
	private var comics = [ResultBook]()
	weak var detailVC: DetailViewController?
	private let repository: IComicsrepository
	private let loadComicsQueue = DispatchQueue(label: "loadHeroesQueue", qos: .userInteractive, attributes: .concurrent)

	init(hero: ResultChar, repository: IComicsrepository) {
		self.hero = hero
		self.repository = repository
	}

	deinit {
		print("DetailContactPresenter deinit")
	}
}

extension DetailPresenter: IDetailPresenter
{
	func countComics() -> Int {
		comics.count
	}

	func getComic(of index: Int) -> ResultBook {
		comics[index]
	}

	func getHero() -> ResultChar {
		hero
	}

	func getComics() {
		loadComicsQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.getComics(of: self.hero.id, completion: { [weak self] comicList in
				guard let self = self else { return }
				DispatchQueue.main.async {
					self.comics = comicList ?? []
					self.detailVC?.show(comics: self.comics)
				}
				return
			})
		}
	}
}
