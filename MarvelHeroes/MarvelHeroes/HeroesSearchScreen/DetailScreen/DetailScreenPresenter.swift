//
//  DetailScreenPresenter.swift
//  MarvelHeroes
//
//  Created by Антон on 05.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//
import Foundation

protocol IDetailScreenData
{
	func startLoading()
	func finishLoading()
	func setEmptyComics()
}

final class DetailScreenPresenter
{
	private let character: Character
	let networkService = NetworkService()
	private weak var detailViewController: DetailScreenViewController?

	init(character: Character) {
		self.character = character
	}

	private var comics = [Series]()

	func getComicsImageData(indexPath: IndexPath, callBack: @escaping (Data) -> Void) {
		guard let path = comics[indexPath.row].thumbnail?.path else { return }
		guard let enlargement = comics[indexPath.row].thumbnail?.enlargement else { return }
		let urlString = path + "." + enlargement
		guard let url = URL(string: urlString) else { return }
		networkService.getImageData(url: url, callBack: { data in
			callBack(data)
		})
	}

	func getComicsAtHeroID() {
		guard let id = character.id?.description else { return }
		networkService.getComicsAtHeroesID(id: id, callBack: { [weak self] seriesDataWrapper in
			guard let data = seriesDataWrapper.data else { return
			}
			guard let results = data.results else { return }
			for comicStrip in results {
				self?.comics.append(comicStrip)
			}
			DispatchQueue.main.async {
				self?.detailViewController?.finishLoading()
			}
		})
	}

	var url: URL? {
		guard let path = character.thumbnail?.path else { return nil }
		guard let enlargement = character.thumbnail?.enlargement else { return nil }
		guard let url = URL(string: path + "." + enlargement) else { return nil }
		return url
	}

	func attachView(detailScreenViewController: DetailScreenViewController) {
		self.detailViewController = detailScreenViewController
		self.detailViewController?.startLoading()
	}

	var comicsCount: Int {
		return self.comics.count
	}

	func getComics(at indexPath: IndexPath) -> Series {
		return self.comics[indexPath.row]
	}

	var imageData: Data? {
		guard let url = url else { return nil }
		let data = try? Data(contentsOf: url)
		return data
	}

	var name: String {
		guard let name = character.name else { return "No name" }
		guard let newName = String(utf8String: name) else { return name }
		return newName
	}

	var description: String {
		guard let description = character.description else { return "No info" }
		guard let newDescription = String(utf8String: description) else { return description }
		return newDescription
	}
}
