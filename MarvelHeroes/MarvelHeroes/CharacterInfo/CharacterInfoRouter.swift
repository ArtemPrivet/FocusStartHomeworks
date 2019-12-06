//
//  CharacterInfoRouter.swift
//  MarvelHeroes
//
//  Created by Максим Шалашников on 05.12.2019.
//  Copyright © 2019 Максим Шалашников. All rights reserved.
//

import Foundation
protocol ICharacterInfoRouter
{
}
final class CharacterInfoRouter: ICharacterInfoRouter
{
	private let builder: IBuilder
	private let view: CharacterInfoViewController

	init(builder: Builder, view: CharacterInfoViewController) {
		self.builder = builder
		self.view = view
	}
}
