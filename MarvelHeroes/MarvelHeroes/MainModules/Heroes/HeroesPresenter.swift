//
//  HeroesPresenter.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 02/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import Foundation

final class HeroesPresenter
{
	private var heroesRouter: IHeroesRouter
	private var repository: IRepository
	weak var heroesView: IHeroesView?

	init(heroesRouter: IHeroesRouter, repository: IRepository) {
		self.heroesRouter = heroesRouter
		self.repository = repository
	}

	private var heroesDataWrapper: HeroesDataWrapper?
	private var heroes: [HeroeViewItem] = []
	private let dispatchGroup = DispatchGroup()
	private let dispatchQueue = DispatchQueue(label: "loadHeroes", qos: .userInitiated)

	final private class HeroeViewItem
	{
		let imageUrl: String?
		var imageData: Data?

		init(imageUrl: String?, imageData: Data? = nil) {
			self.imageUrl = imageUrl
			self.imageData = imageData
		}
	}
}

extension HeroesPresenter: IHeroesPresenter
{
	func getHeroes(withHeroeName name: String?) {
		self.dispatchQueue.async {
			self.loadHeroesImages(withHeroeName: name)
			self.dispatchGroup.notify(queue: .main) {
				self.heroesView?.reloadData(withHeroesCount: self.getHeroesCount())
			}
		}
	}

	func getHeroesCount() -> Int {
		return self.heroesDataWrapper?.data?.results?.count ?? 0
	}

	func getHeroe(at index: Int) -> Heroe? {
		let character = self.heroesDataWrapper?.data?.results?[index]
		return character
	}

	func getHeroeImageData(at index: Int) -> Data? {
		return self.heroes[index].imageData
	}

	func onCellPressed(heroe: Heroe) {
		self.heroesRouter.pushModuleWithHeroeInfo(heroe: heroe)
	}
}

private extension HeroesPresenter
{
	func loadHeroesImages(withHeroeName name: String?) {
		self.dispatchGroup.enter()
		self.repository.getHeroes(withHeroeName: name) { [weak self] heroesResult in
			guard let self = self else { return }
			switch heroesResult {
			case .success(let heroesDataWrapper):
				self.heroesDataWrapper = heroesDataWrapper
				self.getImages()
			case .failure(let error):
				assertionFailure(error.localizedDescription)
			}
			self.dispatchGroup.leave()
		}
		self.dispatchGroup.wait()
	}

	func getImages() {
		self.heroes.removeAll()
		self.heroesDataWrapper?.data?.results?.forEach { heroe in
			if let path = heroe.thumbnail?.path, let thumbnailExtension = heroe.thumbnail?.thumbnailExtension {
				self.heroes.append(HeroeViewItem(imageUrl: path + ImageSize.medium + thumbnailExtension))
			}
		}
		self.heroes.forEach { heroe in
			self.dispatchGroup.enter()
			self.repository.getImage(urlString: heroe.imageUrl ?? "", { [weak self] dataResult in
				guard let self = self else { return }
				switch dataResult {
				case .success(let data):
					if let data = data {
						heroe.imageData = data
					}
				case .failure(let error):
					assertionFailure(error.localizedDescription)
				}
				self.dispatchGroup.leave()
			})
		}
	}
}
