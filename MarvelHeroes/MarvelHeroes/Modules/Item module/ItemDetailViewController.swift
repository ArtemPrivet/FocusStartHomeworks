//
//  ItemDetailViewController.swift
//  MarvelHeroes
//
//  Created by Arkadiy Grigoryanc on 02.12.2019.
//

import UIKit

// MARK: - INavigationItemDetailViewController protocol
protocol INavigationItemDetailViewController: AnyObject
{
	var navigationController: UINavigationController? { get }
}

// MARK: - IItemDetailViewController protocol
protocol IItemDetailViewController: AnyObject
{
	func showItems()
	func showStub()
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
		tableView.separatorStyle = .none
		return tableView
	}()

	private var imageView: UIImageView = {
		let imageView = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		return imageView
	}()

	private lazy var gradientImageView: CAGradientLayer = {
		var color: UIColor = .white
		if #available(iOS 13.0, *) {
			color = . systemBackground
		}
		return self.imageView.addGradientLayerInForeground(
			colors: [color.withAlphaComponent(0.25), color, color, color])
	}()

	private var activityIndicator: UIActivityIndicatorView = {
		let indicator = UIActivityIndicatorView()
		if #available(iOS 13.0, *) {
			indicator.style = .large
			indicator.color = .label
		}
		else {
			indicator.style = .whiteLarge
			indicator.color = .black
		}
		return indicator
	}()

	private var stubView: StubView = {
		let alertView = StubView()
		alertView.isHidden = true
		return alertView
	}()

	private var headerView: HeaderView?

	private var didLoaditems = false
	private var indexPathForSelectedRow: IndexPath?
	private static var cellIdentifier = "ItemCell"

	private let presenter: IItemPresenter

	// MARK: ...Initialization
	init(presenter: IItemPresenter) {
		self.presenter = presenter
		super.init(nibName: nil, bundle: nil)
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
		if let indexPath = indexPathForSelectedRow {
			tableView.deselectRow(at: indexPath, animated: true)
		}
	}

	// MARK: ...Private methods
	private func setup() {

		if #available(iOS 13.0, *) {
			view.backgroundColor = .systemBackground
		}
		else {
			view.backgroundColor = .white
		}

		tableView.register(ItemTableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)

		setNavigationController()
		setHeaderView()

		gradientImageView.frame = view.bounds

		view.addSubview(stubView)
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
		stubView.translatesAutoresizingMaskIntoConstraints = false

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
		let imageViewBottomAnchor = imageView
			.bottomAnchor
			.constraint(equalTo: headerView?.bottomAnchor ?? selfView.bottomAnchor)
		imageViewBottomAnchor.isActive = true
		imageViewBottomAnchor.priority = .defaultHigh

		// Table view constraints
		tableView.leadingAnchor.constraint(equalTo: selfView.leadingAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: selfView.topAnchor).isActive = true
		tableView.trailingAnchor.constraint(equalTo: selfView.trailingAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: selfView.bottomAnchor).isActive = true

		// Activity indicator constraints
		activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
		activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

		// Stub view constraints
		stubView.topAnchor.constraint(equalTo: headerView?.bottomAnchor ?? selfView.topAnchor, constant: -10).isActive = true
		stubView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5).isActive = true
		stubView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
	}

	private func loadData() {
		activityIndicator.startAnimating()
		// Load imgae
		presenter.onThumbnailUpdate(
			by: presenter.detailViewModel.thumbnail,
			aspectRatio: .landscape(.incredible)) { [weak self] image in

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
		let cell = tableView.dequeueReusableCell(withIdentifier: Self.cellIdentifier,
												 for: indexPath) as? ItemTableViewCell
		let viewModel = presenter.tableViewViewModels[indexPath.row]
		cell?.updateIcon(image: nil)
		cell?.configure(using: viewModel)
		presenter.onThumbnailUpdate(by: viewModel.thumbnail,
									aspectRatio: .portrait(.small)) { image in
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

// MARK: - INavigationItemDetailViewController
extension ItemDetailViewController: INavigationItemDetailViewController { }

// MARK: - IItemDetailViewController
extension ItemDetailViewController: IItemDetailViewController
{
	func showItems() {
		activityIndicator.stopAnimating()
		didLoaditems = true
		stubView.isHidden = true
		tableView.separatorStyle = .singleLine
		tableView.reloadData()
	}

	func showStub() {
		activityIndicator.stopAnimating()
		stubView.setTitle("Error")
		stubView.isHidden = false
	}
}
