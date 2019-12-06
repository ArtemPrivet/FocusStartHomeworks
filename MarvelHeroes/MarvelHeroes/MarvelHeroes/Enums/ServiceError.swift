//
//  ServiceError.swift
//  MarvelHeroes
//
//  Created by Саша Руцман on 06/12/2019.
//  Copyright © 2019 Саша Руцман. All rights reserved.
//

import Foundation

enum ServiceError: Error
{
	case sessionError(Error)
	case notFound(Error)
	case dataError(Error)
	case statusCode(Int)
}
