//
//  ItemsRepository.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import Foundation

final class MarvelItemsRepository: IRepository
{
	let remoteDataSource: IRepositoryDataSource

	init(remoteDataSource: IRepositoryDataSource) {
		self.remoteDataSource = remoteDataSource
	}
}
