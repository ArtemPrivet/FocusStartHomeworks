//
//  JSONDataFetcher.swift
//
//
//  Created by Михаил Медведев on 26/07/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//

import UIKit

final class JSONDataFetcher: IJSONDataFetchable
{
	private let networkService: INetworkRequestable
	private let decoder = JSONDecoder()

	init(networkService: INetworkRequestable = NetworkService()) {
		self.networkService = networkService
	}

	/// Fetching Data of Generic Type
	///
	/// - Parameters:
	///   - url: URL
	///   - completion: (T?) -> Void
	func fetchJSONData<T: Decodable>(url: URL,
									 requestType: RequestType,
									 headers: [String: String]?,
									 completion: @escaping (Result<T, NetworkServiceError>) -> Void) {
		DispatchQueue.main.async {
			UIApplication.shared.isNetworkActivityIndicatorVisible = true
		}
		networkService.request(to: url,
							   type: requestType,
							   headers: headers,
							   with: nil,
							   cancelsExitingDataTask: true) { result in
			switch result {
			case .success(let data):
				do {
					let decodedData = try self.decoder.decode(T.self, from: data)
					completion(.success(decodedData))
					DispatchQueue.main.async {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
					}
				}
				catch {
					completion(.failure(.decode(error)))
					DispatchQueue.main.async {
						UIApplication.shared.isNetworkActivityIndicatorVisible = false
					}
				}
			case .failure(let error):
				completion(.failure(error))
				DispatchQueue.main.async {
					UIApplication.shared.isNetworkActivityIndicatorVisible = false
				}
			}
		}
	}
}
