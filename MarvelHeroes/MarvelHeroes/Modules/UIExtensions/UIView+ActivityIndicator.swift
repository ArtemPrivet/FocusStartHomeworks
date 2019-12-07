//
//  UIView+ActivityIndicator.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 07.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

extension UIView
{
	var isHasActivityIndicator: Bool {
		for view in self.subviews where view.tag == 111  { return true }
		return false
	}

	func showActivityIndicatory(delete: Bool) {
		let container = UIView()
		container.tag = 111
		container.frame = self.frame
		container.center = self.center
		if #available(iOS 13.0, *) {
			container.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.3)
		}
		else {
			container.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
		}

		let loadingView = UIView()
		loadingView.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
		loadingView.center = self.center
		loadingView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.7)
		loadingView.clipsToBounds = true
		loadingView.layer.cornerRadius = 10

		let actInd = UIActivityIndicatorView()
		actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
		actInd.style = .whiteLarge
		actInd.center = CGPoint(x: loadingView.frame.size.width / 2,
								y: loadingView.frame.size.height / 2)
		loadingView.addSubview(actInd)
		container.addSubview(loadingView)

		self.addSubview(container)
		actInd.startAnimating()
	}

	func removeActivityIndicator() {
		self.subviews.forEach {
			if $0.tag == 111 {
				$0.removeFromSuperview()
			}
		}
	}
}
