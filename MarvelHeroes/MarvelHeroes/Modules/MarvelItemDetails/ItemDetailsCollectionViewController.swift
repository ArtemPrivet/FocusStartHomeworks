//
//  ItemDetailsCollectionViewController.swift
//  MarvelHeroes
//
//  Created by Mikhail Medvedev on 05.12.2019.
//  Copyright © 2019 Mikhail Medvedev. All rights reserved.
//  swiftlint:disable required_final

import UIKit

class ItemDetailsCollectionViewController: UICollectionViewController
{
	private let presenter: IDetailItemPresentable

	private let cellId = "MarvelItemCollectionCell"
	private let headerId = "HeaderId"
	private let titleText = "Related Items"

	var header: HeaderCollectionView?

	init(collectionViewLayout layout: UICollectionViewLayout, presenter: IDetailItemPresentable) {
		self.presenter = presenter
		super.init(collectionViewLayout: layout)
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		if navigationController?.restorationIdentifier == ModulesFactory.secondaryId {
			title = titleText
		}
		setupCollectionView()
		customizeCollectionViewLayout()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		header?.animator?.stopAnimation(true)
		header?.animator?.finishAnimation(at: .current)
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

	func animateChangeItemTransition(reversed: Bool) {
		self.collectionView.isScrollEnabled = reversed
		UIView.animate(withDuration: 0.3) {
			self.collectionView.transform = reversed ? .identity : CGAffineTransform(scaleX: 2, y: 2)
			self.header?.titleLabel.alpha = reversed ? 1: 0
			self.header?.descriptionTextView.alpha = reversed ? 1: 0
			self.header?.animator?.fractionComplete = reversed ? 0 : 1
		}
	}
}

extension ItemDetailsCollectionViewController
{
	override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		presenter.getSubItemsCount()
	}

	override func collectionView(_ collectionView: UICollectionView,
								 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(
			withReuseIdentifier: cellId, for: indexPath) as? DetailItemCollectionViewCell
			else { return UICollectionViewCell() }

		let subitem = presenter.getSubItem(index: indexPath.item)

		cell.configure(with: subitem.name, resourceURI: subitem.resourceURI)

		presenter.getImageURLFor(cell: cell, index: indexPath.item)

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

		animateChangeItemTransition(reversed: false)
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
		if navigationController?.restorationIdentifier == ModulesFactory.primaryId {
		title = offset > 200 ? titleText : nil
		}
	}
}
