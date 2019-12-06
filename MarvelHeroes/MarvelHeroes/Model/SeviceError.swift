//
//  SeviceError.swift
//  MarvelHeroes
//
//  Created by Stanislav on 06/12/2019.
//  Copyright © 2019 Stanislav Kozlov. All rights reserved.
//

import Foundation

enum ServiceError: Error
{
	case networkError
	case httpError(Int)
	case parsingError(Error)
	case dataError

	func errorHandler(completion: (String) -> Void ) {
		switch self {
		case .dataError:
			completion("Getting data error")
		case .httpError(let httpErrorCode):
			completion("Http request error: \(httpErrorCode)")
		case .networkError:
			completion("Connection problem")
		case .parsingError(let error):
			completion("Data format error \(error)")
		}
	}
}
