//
//  IItemTableViewCellProtocol.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 04.12.2019.
//

import UIKit

protocol IItemTableViewCell
{
	func configure(using viewModel: IItemViewModel)
	func updateIcon(image: UIImage?)
}
