//
//  TestDetailPresenter.swift
//  MarvelHeroes
//
//  Created by Антон on 07.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation
protocol IDetailPresenter
{
	func attachViewController(viewController: DetailViewController)
	func getDataForTableView()
	func getTextForCell(at indexPath: IndexPath) -> String?
	func getDetailTextForCell(at indexPath: IndexPath) -> String?
	func getImageDataForCell(at indexPath: IndexPath, callBack: @escaping (Data) -> Void)
	func tapToRow(at indexPath: IndexPath)

	var getNameOrTitleLabelText: String { get }
	var getDescriptionLabelText: String { get }
	var imageData: Data? { get }
	var numberOfRows: Int { get }
}

final class DetailPresenter
{
	private let model: StructForPresenterArray
	private let presenterType: PresenterType
	private var viewController: DetailViewController?
	private let networkService = NetworkService()
	private let router = Router()
	private var series: SeriesDataWrapper? {
		didSet {
			self.modelArray.removeAll()
			guard let results = series?.data?.results else { return }
			for element in results {
				guard let id = element.id else { continue }
				guard let title = element.title else { continue }
				guard let description = element.description else { continue }
				guard let path = element.thumbnail?.path else { continue }
				guard let enlargement = element.thumbnail?.enlargement else { continue }
				guard let url = URL(string: path + "." + enlargement) else { continue }
				let model = StructForPresenterArray(text: title, detailText: description, imageURL: url, id: id)
				modelArray.append(model)
			}
			DispatchQueue.main.async {
				self.viewController?.finishLoading()
			}
		}
	}
	private var creators: CreatorDataWrapper? {
		didSet {
			self.modelArray.removeAll()
			guard let results = creators?.data?.results else { return }
			for element in results {
				guard let id = element.id else { continue }
				guard let fullName = element.fullName else { continue }
				guard let path = element.thumbnail?.path else { continue }
				guard let enlargement = element.thumbnail?.enlargement else { continue }
				guard let url = URL(string: path + "." + enlargement) else { continue }
				let model = StructForPresenterArray(text: fullName, detailText: nil, imageURL: url, id: id)
				modelArray.append(model)
			}
			DispatchQueue.main.async {
				self.viewController?.finishLoading()
			}
		}
	}
	private var heroes: CharacterDataWrapper? {
		didSet {
			guard let data = heroes?.data else { return }
			guard let result = data.results else { return }
			guard result.isEmpty != true else { return }
			for model in result {
				var modifiedModel = model
				if modifiedModel.description == nil ||
				modifiedModel.description == " " ||
				modifiedModel.description?.isEmpty == true {
					modifiedModel.description = "No info"
				}
				let text = model.name
				let detailText = modifiedModel.description
				guard let path = model.thumbnail?.path else { return }
				guard let enlargement = model.thumbnail?.enlargement else { return }
				guard let url = URL(string: path + "." + enlargement) else { return }
				let id = modifiedModel.id
				let modelStructForPresenterArray = StructForPresenterArray(text: text,
																		   detailText: detailText,
																		   imageURL: url,
																		   id: id)
				modelArray.append(modelStructForPresenterArray)
			}
			DispatchQueue.main.async {
				self.viewController?.finishLoading()
			}
		}
	}
	private var modelArray = [StructForPresenterArray]()

	init(model: StructForPresenterArray, presenterType: PresenterType) {
		self.model = model
		self.presenterType = presenterType
	}
}
extension DetailPresenter: IDetailPresenter
{
	func tapToRow(at indexPath: IndexPath) {
		switch presenterType {
		case .heroScreenDetail:
			let model = modelArray[indexPath.row]
			guard let viewcontroller = self.viewController else { return }
			router.showDetailForDetailViewController(detailViewController: viewcontroller,
													 model: model,
													 presenterType: .comicsScreenDetail)
		case .comicsScreenDetail:
			let model = modelArray[indexPath.row]
			guard let viewController = self.viewController else { return }
			router.showDetailForDetailViewController(detailViewController: viewController,
													 model: model,
													 presenterType: .authorsScreenDetail)
		case .authorsScreenDetail:
			let model = modelArray[indexPath.row]
			guard let viewController = self.viewController else { return }
			router.showDetailForDetailViewController(detailViewController: viewController, model: model,
													 presenterType: .presentHeroesInComics)
		case .presentHeroesInComics:
			let model = modelArray[indexPath.row]
			guard let viewController = self.viewController else { return }
			router.showDetailForDetailViewController(detailViewController: viewController, model: model,
													 presenterType: .heroScreenDetail)
		default:
			break
		}
	}

	func getTextForCell(at indexPath: IndexPath) -> String? {
		return modelArray[indexPath.row].text
	}
	func getDetailTextForCell(at indexPath: IndexPath) -> String? {
		return modelArray[indexPath.row].detailText
	}
	func getImageDataForCell(at indexPath: IndexPath, callBack: @escaping (Data) -> Void) {
		guard let url = modelArray[indexPath.row].imageURL else { return }
		networkService.getImageData(url: url) { data in
			DispatchQueue.main.async {
				callBack(data)
			}
		}
	}

	func getDataForTableView() {
		viewController?.startLoading()
		switch presenterType {
		case .heroScreenDetail:
			guard let id = model.id else { return }
			self.networkService.getComicsAtHeroesID(id: id.description, callBack: { [weak self] seriesResult in
				do {
					self?.series = try seriesResult.get()
				}
				catch {
					assert(true, error.localizedDescription)
				}
			})
		case .comicsScreenDetail:
			guard let id = model.id else { return }
			self.networkService.getAuthorsAtComicsId(id: id.description) { [weak self] creatorResult in
				do {
					self?.creators = try creatorResult.get()
				}
				catch {
					assert(true, error.localizedDescription)
				}
			}
		case .authorsScreenDetail:
			guard let id = model.id else { return }
			self.networkService.getComicsAtCreatorsID(id: id.description, callBack: { [weak self] seriesResult in
				do {
					self?.series = try seriesResult.get()
				}
				catch {
					assert(true, error.localizedDescription)
				}
			})
		case .presentHeroesInComics:
			guard let id = model.id else { return }
			self.networkService.getCharacterInComicsAtComicsID(id: id.description, callBack: { [weak self] characterResult in
				do {
					self?.heroes = try characterResult.get()
				}
				catch {
					assert(true, error.localizedDescription)
				}
			})
		default:
			break
		}
	}

	func attachViewController(viewController: DetailViewController) {
		self.viewController = viewController
	}

	var numberOfRows: Int {
		return modelArray.count
	}

	var imageData: Data? {
		guard let url = model.imageURL else { return nil }
		let data = try? Data(contentsOf: url)
		return data
	}

	var getNameOrTitleLabelText: String {
		guard let text = self.model.text else { return "No info" }
		return text
	}

	var getDescriptionLabelText: String {
		guard let text = self.model.detailText else { return "No info" }
		return text
	}
}
