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
	func getHeroesImageData(url: URL, callBack: @escaping (Data) -> Void)
	func getHeroes(charactersName: String, callBack: @escaping (CharacterDataWrapper) -> Void)
}
