//
//  DetailPresenter.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class DetailPresenter
{
	private let hero: ResultChar
	private var comics = [ResultBook]()
	private var comicImage = UIImage()
	weak var detailVC: DetailViewController?
	private let repository: IComicsRepository
	private let loadComicsQueue = DispatchQueue(label: "loadHeroesQueue", qos: .userInteractive, attributes: .concurrent)

	init(hero: ResultChar, repository: IComicsRepository) {
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
					switch comicList {
					case .success(let data):
							self.comics = data
					case .failure(.noData):
						self.comics = []
					case .failure(.invalidURL(let error)):
						self.comics = []
						print(error)
					case .failure(.noResponse):
						self.comics = []
					}
					self.detailVC?.show(comics: self.comics)
				}
				return
			})
		}
	}

	func getImage() -> UIImage {
			let imagePath = self.getHero().thumbnail
			if let url = URL(string: "\(imagePath.path)/standard_xlarge.\(imagePath.thumbnailExtension)"),
				let heroDataImage = try? Data(contentsOf: url){
				if let image = UIImage(data: heroDataImage) {
					self.comicImage = image
				}
			}
		return self.comicImage
	}
}
