//
//  Extensions.swift
//  MarvelHeroes
//
//  Created by Антон on 01.12.2019.
//  Copyright © 2019 Anton Belov. All rights reserved.
//

import Foundation
import UIKit
import CommonCrypto

extension String
{
	var md5: String {
		let data = Data(self.utf8)
		let hash = data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) -> [UInt8] in
			var hash = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
			CC_MD5(bytes.baseAddress, CC_LONG(data.count), &hash)
			return hash
		}
		return hash.map { String(format: "%02x", $0) }.joined()
	}
}

extension Date
{
	func toMillis() -> Int64! {
		return Int64(self.timeIntervalSince1970 * 1000)
	}
}
extension UIImage
{
	func imageWithImage(scaledToSize newSize: CGSize) -> UIImage? {

		UIGraphicsBeginImageContext( newSize )
		self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
		let newImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		return newImage?.withRenderingMode(.alwaysOriginal)
	}
}
extension UIView
{
	// For insert layer in Foreground
	func addGradientLayerInForeground(colors: [UIColor]) {
		let gradient = CAGradientLayer()
		gradient.frame = CGRect(origin: .zero, size: self.frame.size)
		gradient.colors = colors.map{ $0.cgColor }
		self.layer.addSublayer(gradient)
	}
	// For insert layer in background
	func addGradientLayerInBackground(colors: [UIColor]) {
		let gradient = CAGradientLayer()
		gradient.frame = CGRect(origin: .zero, size: self.frame.size)
		gradient.colors = colors.map{ $0.cgColor }
		self.layer.insertSublayer(gradient, at: 0)
	}

	func showActivityIndicatory(containerAcitivtyIndicator: UIView,
								loadingView: UIView,
								activityIndicator: UIActivityIndicatorView) {
		containerAcitivtyIndicator.frame = self.frame
		containerAcitivtyIndicator.center = self.center
		containerAcitivtyIndicator.backgroundColor = self.backgroundColor

		loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
		loadingView.center = self.center
		loadingView.backgroundColor = UIColor.gray.withAlphaComponent(0.7)
		loadingView.clipsToBounds = true
		loadingView.layer.cornerRadius = 10

		activityIndicator.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		activityIndicator.style = .whiteLarge
		activityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
		loadingView.addSubview(activityIndicator)
		containerAcitivtyIndicator.addSubview(loadingView)
		self.addSubview(containerAcitivtyIndicator)
		activityIndicator.startAnimating()
	}
}
