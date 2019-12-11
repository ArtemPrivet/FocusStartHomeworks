//
//  HeroPresenter.swift
//  MarvelHeroes
//
//  Created by Igor Shelginskiy on 12/5/19.
//  Copyright © 2019 Igor Shelginskiy. All rights reserved.
//

import UIKit

final class HeroPresenter
{
	private var repository: IHeroRepository
	private var router: IHeroRouter
	weak var heroVC: HeroViewController?
	private let loadHeroesQueue = DispatchQueue(label: "loadHeroesQueue", qos: .userInteractive, attributes: .concurrent)
	private var heroes = [ResultChar]()
	private var heroImage = UIImage()

	init(repository: IHeroRepository, router: IHeroRouter) {
		self.repository = repository
		self.router = router
	}
}

extension HeroPresenter: IHeroPresenter
{
	var heroesCount: Int { heroes.count }

	func showDetail(of index: Int) {
		router.showDetail(with: heroes[index])
	}

	func getHero(of index: Int) -> ResultChar {
		heroes[index]
	}

	func showAlert(with title: String, text: String) {
		let alert = UIAlertController(title: title, message: text, preferredStyle: .alert)
		alert.addAction(.init(title: title, style: .default, handler: nil))
	}

	func getHeroes(of text: String) {
		loadHeroesQueue.async { [weak self] in
			guard let self = self else { return }
			self.repository.getHeroes(of: text, completion: { [weak self] heroList in
				guard let self = self else { return }
				DispatchQueue.main.async {
					switch heroList {
					case .success(let data):
						self.heroes = data
					case .failure(.noData):
						self.heroes = []
					case .failure(.invalidURL(let error)):
						self.heroes = []
						self.showAlert(with: text, text: "\(error)")
					case .failure(.noResponse):
						self.heroes = []
					}
					self.heroVC?.show(heroes: self.heroes)
				}
			})
		}
	}
	func getImage(of index: Int) -> UIImage {
		let hero = self.heroes[index]
		loadHeroesQueue.async { [weak self] in
			if let url = URL(string: "\(hero.thumbnail.path)/standard_medium.\(hero.thumbnail.thumbnailExtension)"),
				let heroDataImage = try? Data(contentsOf: url) {
				DispatchQueue.main.async {
					if let image = UIImage(data: heroDataImage) {
						self?.heroImage = image
					}
				}
			}
		}
		return self.heroImage
	}
}
