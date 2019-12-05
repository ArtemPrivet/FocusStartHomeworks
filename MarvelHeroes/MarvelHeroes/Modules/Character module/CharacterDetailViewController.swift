//
//  ItemDetailViewController.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import UIKit

// MARK: - IItemViewController protocol
protocol IItemViewController: AnyObject
{
	var navController: UINavigationController? { get }

	func showItems()
	func showAlert()
}

// MARK: - Class
final class ItemDetailViewController: UIViewController
{

	// MARK: ...Private properties
	private lazy var tableView: UITableView = {
		let tableView = UITableView()
		tableView.delegate = self
		tableView.dataSource = self
		tableView.backgroundColor = .clear
		return tableView
	}()

	private var imageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()

	private lazy var gradientImageView: CAGradientLayer = {
		if #available(iOS 13.0, *) {
			return self.imageView.addGradientLayerInForeground(
				colors: [
					UIColor.systemBackground.withAlphaComponent(0.25),
					UIColor.systemBackground,
					UIColor.systemBackground,
			])
		}
		else {
			return self.imageView.addGradientLayerInForeground(
				colors: [
					UIColor.white.withAlphaComponent(0.25),
					UIColor.white,
					UIColor.white,
			])
		}
	}()

	private var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		if #available(iOS 13.0, *) {
			indicator.color = .label
			indicator.style = .large
		}
		else {
			indicator.color = .black
			indicator.style = .whiteLarge
		}
		return indicator
	}()

	private var headerView: HeaderView?

	private var didLoaditems = false
	private var indexPathForSelectedRow: IndexPath?

	private let presenter: IItemPresenter

	// MARK: ...Initialization
	init(presenter: IItemPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
		print("Init")
	}

	@available(*, unavailable)
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: ...Life cycle
	override func viewDidLoad() {
		super.viewDidLoad()

		setup()
		setConstraints()

		loadData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		navigationItem.largeTitleDisplayMode = .automatic
		if let indexPath = indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	// MARK: ...Private methods
	private func setup() {

		view.backgroundColor = .systemBackground

		tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: "Cell")

		setNavigationController()
		setHeaderView()

		gradientImageView.frame = view.bounds

		view.addSubview(imageView)
		view.addSubview(tableView)
		view.addSubview(activityIndicator)
	}

	private func setNavigationController() {
		navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
		navigationController?.navigationBar.shadowImage = UIImage()
		navigationController?.navigationBar.isTranslucent = true
		navigationController?.view.backgroundColor = .clear
	}

	private func setHeaderView() {
		headerView = HeaderView(withWidth: view.frame.width,
								titleText: presenter.detailViewModel.title,
								descriptionText: presenter.detailViewModel.description)
		tableView.tableHeaderView = headerView
		tableView.tableHeaderView?.backgroundColor = .clear
		tableView.tableHeaderView?.frame = CGRect(x: 0, y: 0, width: 0, height: headerView?.frame.height ?? 0)
	}

	private func setConstraints() {
		imageView.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		activityIndicator.translatesAutoresizingMaskIntoConstraints = false

		var selfView: UILayoutGuide
		if #available(iOS 11.0, *) {
			selfView = self.view.safeAreaLayoutGuide
		}
		else {
			selfView = self.view.layoutMarginsGuide
		}

		// Image view constraints
		imageView.heightAnchor.constraint(greaterThanOrEqualToConstant: 0).isActive = true
		imageView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor).isActive = true
		imageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
		imageView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor).isActive = true
		let imageViewBottomAnchor = NSLayoutConstraint(
			item: imageView,
			attribute: .bottom,
			relatedBy: .equal,
			toItem: headerView,
			attribute: .bottom,
			multiplier: 1,
			constant: 0)
		imageViewBottomAnchor.priority = .defaultHigh
		imageViewBottomAnchor.isActive = true

		// Table view constraints
		tableView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: selfView.topAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: selfView.bottomAnchor).isActive = true

		// Activity indicator constraints
		activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
	}

	private func loadData() {
		activityIndicator.startAnimating()
		// Load imgae
		presenter.onThumbnailUpdate(
			by: presenter.detailViewModel.thumbnail.path,
			extension: presenter.detailViewModel.thumbnail.extension.rawValue) { [weak self] image in
					self?.imageView.image = image
		}

		// Load items
		presenter.loadItems()
	}
}

// MARK: - Table view data source
extension ItemDetailViewController: UITableViewDataSource
{
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		presenter.tableViewViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? ItemTableViewCell
		let viewModel = presenter.tableViewViewModels[indexPath.row]
		cell?.updateIcon(image: nil)
//		cell?.updateIcon(image: #imageLiteral(resourceName: "placeholder"))
		cell?.configure(using: viewModel)
		presenter.onThumbnailUpdate(
			by: viewModel.thumbnail.path,
			extension: viewModel.thumbnail.extension.rawValue) { image in
			cell?.updateIcon(image: image)
		}
		return cell ?? UITableViewCell()
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard didLoaditems && presenter.tableViewViewModels.isEmpty else { return nil }
		let label = UILabel()
		label.font = .systemFont(ofSize: 30)
		label.text = "No data"
		label.textAlignment = .center
		return label
	}

	func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		didLoaditems && presenter.tableViewViewModels.isEmpty ? UIView() : nil
	}
}

// MARK: - Table view delegate
extension ItemDetailViewController: UITableViewDelegate
{
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		presenter.showDetail(viewModel: presenter.tableViewViewModels[indexPath.row])
		indexPathForSelectedRow = indexPath
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		didLoaditems && presenter.tableViewViewModels.isEmpty ? 10 : 0
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		didLoaditems && presenter.tableViewViewModels.isEmpty ? 30 : 0
	}
}

// MARK: - IItemViewController
extension ItemDetailViewController: IItemViewController
{
	var navController: UINavigationController? { navigationController }

	func showItems() {
		activityIndicator.stopAnimating()
		didLoaditems = true
		tableView.reloadData()
	}

	func showAlert() {
		activityIndicator.stopAnimating()
	}
}
