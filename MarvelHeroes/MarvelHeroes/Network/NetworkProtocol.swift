//
//  NetworkProtocol.swift
//  MarvelHeroes
//
//  Created by Антон on 01.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation
protocol INetworkProtocol
{
	func getImageData(url: URL, callBack: @escaping (Data) -> Void)
	func getHeroes(charactersName: String, callBack: @escaping (CharacterResult) -> Void)
	func getComicsAtHeroesID(id: String, callBack: @escaping (SeriesResult) -> Void)
	func getComicsAtCreatorsID(id: String, callBack: @escaping (SeriesResult) -> Void)
	func getComicsAtNameStartsWith(string: String, callBack: @escaping (SeriesResult) -> Void)
	func getCharacterInComicsAtComicsID(id: String, callBack: @escaping (CharacterResult) -> Void)
	func getAuthorsAtNameStartsWith(string: String, callBack: @escaping (CreatorsResult) -> Void)
	func getAuthorsAtComicsId(id: String, callBack: @escaping (CreatorsResult) -> Void)
}
