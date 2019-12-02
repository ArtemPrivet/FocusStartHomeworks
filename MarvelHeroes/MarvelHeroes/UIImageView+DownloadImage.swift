//
//  UIImageView+DownloadImage.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import UIKit

extension UIImageView {
	func downloadImageFrom(link: String, contentMode: ContentMode) {
		guard let url = URL(string: link) else { return }
		//image = nil
		URLSession.shared.dataTask(with: url) { data, _, _ in
			DispatchQueue.main.async {
				self.contentMode =  contentMode
                if let data = data {
					self.image = UIImage(data: data)
				}
			}
		}.resume()
    }
}
