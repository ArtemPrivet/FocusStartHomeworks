//
//  IHeroesView.swift
//  MarvelHeroes
//
//  Created by Иван Медведев on 03/12/2019.
//  Copyright © 2019 Medvedev. All rights reserved.
//

import UIKit

protocol IHeroesView: AnyObject
{
	func reloadData(withHeroesCount count: Int)
}
