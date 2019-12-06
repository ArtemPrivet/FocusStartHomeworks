//
//  IEntity.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

protocol IEntity: Decodable
{
	var id: Int { get }
	var showingName: String? { get }
	var description: String? { get }
	var squareImageURL: URL? { get }
	var portraitImageURL: URL? { get }
	var bigImageURL: URL? { get }
}
