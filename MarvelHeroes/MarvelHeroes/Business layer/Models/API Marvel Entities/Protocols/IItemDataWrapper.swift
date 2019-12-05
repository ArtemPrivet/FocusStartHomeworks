//
//  IItemDataWrapper.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 05.12.2019.
//

import Foundation

protocol IItemDataWrapper: Codable { }

extension IItemDataWrapper
{
	init(data: Data, decoder: JSONDecoder) throws {
		do {
			self = try decoder.decode(Self.self, from: data)
		}
		catch {
			throw error
		}
	}
}
