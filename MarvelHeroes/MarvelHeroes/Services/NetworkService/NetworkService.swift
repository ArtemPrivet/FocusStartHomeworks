//
//  NetworkService.swift
//  
//
//  Created by Михаил Медведев on 26/07/2019.
//  Copyright © 2019 Михаил Медведев. All rights reserved.
//  swiftlint:disable function_parameter_count

import Foundation

final class NetworkService: NetworkRequestable
{
	private var dataTask: URLSessionDataTask?
	/// Creates Data Task with request
	///
	/// - Parameters:
	///   - request: URLRequest
	///   - completion: (Result<Data, NetworkServiceError>) -> Void
	/// - Returns: URLSessionDataTask
	private func createDataTask(with request: URLRequest,
								completion: @escaping (Result<Data, NetworkServiceError>) -> Void) -> URLSessionDataTask {
		return URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in
			if let error = error {
				DispatchQueue.main.async {
					completion(.failure(.serverError(error)))
				}
				return
			}

			guard let response = response as? HTTPURLResponse else {
				DispatchQueue.main.async {
					completion(.failure(.noHTTPResponse))
				}
				return
			}

			switch response.statusCode {
			case 400..<500:
				if response.statusCode == 429 {
					completion(.failure(.tooManyRequests))
					return
				}
				completion(.failure(.clientError))
				return
			case 500..<600:
				completion(.failure(.serverResponseError))
				return
			default: break
			}

			if let data = data {
				DispatchQueue.main.async {
					completion(.success(data))
				}
			}
			else {
				DispatchQueue.main.async {
					completion(.failure(.noData))
				}
			}
		})
	}

	/// Make request to specified URL
	func request(to url: URL?,
				 type: RequestType,
				 headers: [String: String]?,
				 with data: Data?,
				 cancelsExitingDataTask: Bool,
				 responseHandler: @escaping (Result<Data, NetworkServiceError>) -> Void) {

		if cancelsExitingDataTask {
			dataTask?.cancel()
		}

		guard let url = url else {
			responseHandler(.failure(.wrongURL))
			return
		}

		var request = URLRequest(url: url)
		request.allHTTPHeaderFields = headers

		switch type {
		case .get: request.httpMethod = RequestType.get.rawValue
		case .post: request.httpMethod = RequestType.post.rawValue
		case .put: request.httpMethod = RequestType.put.rawValue
		case .delete: request.httpMethod = RequestType.delete.rawValue
		case .update: request.httpMethod = RequestType.update.rawValue
		case .patch: request.httpMethod = RequestType.patch.rawValue
		}

		if let data = data {
			request.httpBody = data
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		}

		dataTask = createDataTask(with: request, completion: responseHandler)

		dataTask?.resume()
	}
}
