//
//  ItemDetailsCollectionViewController.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 05.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//

import UIKit

protocol IItemDetailsList
{
	var marvelItemType: MarvelItemType { get }
	var isModallyPresented: Bool { get }

	func setHeaderImage(image: UIImage)
	func setStubView(withImage: Bool, message: String, animated: Bool)
	func reloadSection()
	func removeStubView()
	func removeActivityIndicator()
}

final class ItemDetailsCollectionViewController: UICollectionViewController
{
	private let presenter: IDetailItemPresentable
	let marvelItemType: MarvelItemType

	private let cellId = "MarvelItemCollectionCell"
	private let headerId = "HeaderId"
	private let titleText = "Related Items"

	private var header: HeaderCollectionView?

	init(collectionViewLayout layout: UICollectionViewLayout,
		 presenter: IDetailItemPresentable,
		 marvelItemType: MarvelItemType) {
		self.presenter = presenter
		self.marvelItemType = marvelItemType
		super.init(collectionViewLayout: layout)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		if isModallyPresented { title = titleText }
		setupCollectionView()
		customizeCollectionViewLayout()
		collectionView.showActivityIndicatory(delete: false)
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		header?.animator?.stopAnimation(true)
	}

	private func setupCollectionView() {
		collectionView.contentInsetAdjustmentBehavior = .never
		if #available(iOS 13.0, *) {
			collectionView.backgroundColor = .systemBackground
		}
		else { collectionView.backgroundColor = .white }

		collectionView.register(HeaderCollectionView.self,
								forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
								withReuseIdentifier: headerId)
		collectionView.register(
				DetailItemCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
	}

	private func customizeCollectionViewLayout() {
		if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
			layout.sectionInset = .init(top: Metrics.layoutPadding,
										left: 0,
										bottom: Metrics.layoutPadding,
										right: 0)
		}
	}

	private func configureHeaderView() {
		let item = presenter.getItem()

		if let heroItem = item as? Hero {
			header?.titleLabel.text = heroItem.name
			header?.descriptionTextView.text = (heroItem.description?.isEmpty ?? true) ?
			"There is no description for this hero..." : heroItem.description
		}
		else if let comicsItem = item as? Comics {
			header?.titleLabel.text = comicsItem.title
			header?.descriptionTextView.text = comicsItem.description ??
			"There is no description for this comics..."
		}
		else if let authorItem = item as? Author {
			header?.titleLabel.text = authorItem.fullName
		}

		presenter.setHeaderImage()
	}
}

extension ItemDetailsCollectionViewController: IItemDetailsList
{
	func removeActivityIndicator() {
		collectionView.removeActivityIndicator()
	}

	func reloadSection() {
		collectionView.reloadSections([0])
	}

	func setStubView(withImage: Bool, message: String, animated: Bool) {
		collectionView.setStubView(withImage: withImage, message: message, animated: animated)
	}

	func removeStubView() {
		collectionView.restore()
	}

	func setHeaderImage(image: UIImage) {
		header?.imageView.image = image
		UIView.animate(withDuration: 1) {
			self.header?.imageView.alpha = 1
		}
	}
}

extension ItemDetailsCollectionViewController
{
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		if presenter.getSubItemsCount() == 0,
			collectionView.isHasActivityIndicator == false {
			collectionView.setStubView(withImage: true, animated: true)
		}
		return presenter.getSubItemsCount()
	}

	override func collectionView(_ collectionView: UICollectionView,
								 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: cellId, for: indexPath) as? DetailItemCollectionViewCell
			else { return UICollectionViewCell() }

		cell.setImage(Thumbnail.placeholder)

		let item = presenter.getSubItem(index: indexPath.item)

		if let comicsItem = item as? Comics {
			cell.thumbPath = comicsItem.thumbnail.path
			cell.configure(with: comicsItem.title, info: comicsItem.description)
		}
		else if let authorItem = item as? Author {
			cell.thumbPath = authorItem.thumbnail.path
			cell.configure(with: authorItem.fullName, info: nil)
		}

		if cell.currentImage === Thumbnail.placeholder {
		presenter.setImageToCell(useIndex: indexPath.item, cell: cell)
		}

		return cell
	}

	// MARK: - Header
	override func collectionView(_ collectionView: UICollectionView,
								 viewForSupplementaryElementOfKind kind: String,
								 at indexPath: IndexPath) -> UICollectionReusableView {

		header = collectionView.dequeueReusableSupplementaryView(
			ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as? HeaderCollectionView

		configureHeaderView()

		return header ?? UICollectionReusableView()
	}

	 func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						referenceSizeForHeaderInSection section: Int) -> CGSize {
		CGSize(width: view.frame.width, height: Metrics.headerHeight)
	}

	// MARK: MAKE TRANSITION
	override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		presenter.onPressed(index: indexPath.item)
	}
}

extension ItemDetailsCollectionViewController: UICollectionViewDelegateFlowLayout
{
	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: view.frame.width,
					  height: Metrics.rowHeight)
	}
}

// MARK: - UIScrollViewDelegate
extension ItemDetailsCollectionViewController
{
	override func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let offset = scrollView.contentOffset.y
		header?.animator?.fractionComplete = offset < 0 ? abs(offset) / 100 : 0
		if isModallyPresented == false {
		title = offset > 200 ? titleText : nil
		}
	}
}
