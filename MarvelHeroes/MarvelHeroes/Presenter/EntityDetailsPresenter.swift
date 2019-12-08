//
//  EntityDetailsPresenter.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

protocol IEntityDetailsPresenter: AnyObject
{
	var recordsCount: Int { get }
	var currentRecord: IEntity { get }

	func inject(router: IEntityDetailsRouter, repository: Repository, view: IDetailsView)
	func onAccessoryPressed(index: Int)
	func triggerViewReadyEvent()
	func getRecord(index: Int) -> IEntity
}

final class EntityDetailsPresenter
{
	private let entity: IEntity
	private let entityType: EntityType
	private weak var view: IDetailsView?
	private var router: IEntityDetailsRouter?
	private var accesories: [IEntity] = []
	private var repository: Repository?

	init(entity: IEntity, with entityType: EntityType) {
		self.entity = entity
		self.entityType = entityType
	}
}

extension EntityDetailsPresenter: IEntityDetailsPresenter
{
	var currentRecord: IEntity {
		return entity
	}

	var recordsCount: Int {
		return accesories.count
	}

	func getRecord(index: Int) -> IEntity {
		return accesories[index]
	}
	func triggerViewReadyEvent() {
		loadAccessoryByEntityID()
	}
	func onAccessoryPressed(index: Int) {
		router?.routeToAccessory(accessory: accesories[index])
	}

	func inject(router: IEntityDetailsRouter, repository: Repository, view: IDetailsView) {
		self.view = view
		self.router = router
		self.repository = repository
	}
}

private extension EntityDetailsPresenter
{
	//Загрузка дополнительных данных для текущей записи
	func loadAccessoryByEntityID() {
		view?.startSpinnerAnimation()
		let directory = entityType.directoryOfAccessories(id: entity.id)
		switch entityType {
		case .character, .author:
			var _: ComicsResponse? = callRequest(directory: directory)
		case .comics:
			var _: AuthorResponse? = callRequest(directory: directory)
		}
	}

	func callRequest<T: Decodable>(directory: String) -> T? {
		guard let localRepository = repository else { return nil }
		localRepository.loadAccessoryByEntityID(from: directory) { [weak self] (result: Result<T, ServiceError>) in
			switch result {
			case .success(let accessories):
				if let data = accessories as? CharacterResponse {
					self?.accesories = data.data.results
				}
				if let data = accessories as? ComicsResponse {
					self?.accesories = data.data.results
				}
				if let data = accessories as? AuthorResponse {
					self?.accesories = data.data.results
				}
			case .failure(let error):
				error.errorHandler { errorMessage in
					self?.router?.showAlert(with: errorMessage)
				}
				self?.accesories = []
			}
			self?.view?.reloadData()
			self?.view?.stopSpinnerAnimation()
		}
		return nil
	}
}
