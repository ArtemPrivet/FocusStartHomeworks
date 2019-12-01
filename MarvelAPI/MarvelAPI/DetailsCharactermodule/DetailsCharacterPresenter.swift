//
//  DetailsCharacterPresenter.swift
//  MarvelAPI
//
//  Created by Kirill Fedorov on 01.12.2019.
//  Copyright © 2019 Kirill Fedorov. All rights reserved.
//

import Foundation

protocol IDetailsCharacterPresenter {
	func getCharacter() -> Character
}

class DetailsCharacterPresenter {
	var character: Character
	
	init(character: Character) {
		self.character = character
	}
	deinit {
		print("DetailsPresenter deinit")
	}
}

extension DetailsCharacterPresenter: IDetailsCharacterPresenter {
	func getCharacter() -> Character {
		return character
	}
}
