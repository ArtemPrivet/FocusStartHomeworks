//
//  IRepository.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 01.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IRepository
{
	func fetchMarvelItems<T: Decodable>(type: MarvelItemType,
										appendingPath: String?,
										withId: Int?,
										searchText: String,
										completion: @escaping (Result<T, NetworkServiceError>) -> Void)

	func fetchMarvelItem<T: Decodable>(resourceLink: String,
									   completion: @escaping (Result<T, NetworkServiceError>) -> Void)

	func fetchImage(url: URL, completion: @escaping (Result<UIImage, NetworkServiceError>) -> Void)
}
