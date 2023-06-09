//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit

final class StoreViewController: ESBaseViewController<StoreViewModel> {
	
	private typealias C = Constants
	private enum Constants {
		static let title = "Hello"
		static let titleTab1 = "Local eSIMs"
		static let titleTab2 = "Regional eSIMs"
		static let titleTab3 = "Global eSIMs"
		static let searchPlaceholder = "Search data packs for +190 countries and regions"
		static let offset: CGFloat = 8
		static let minimalHeight: CGFloat = 44
		static var offsetTop: CGFloat = 50
	}
	
	private var searchBarView: SearchBarView!
	private let segmentedControl = ColoredSegmentedControl(items: [C.titleTab1, C.titleTab2, C.titleTab3])
	
	private let rightNavButton = UIBarButtonItem(image: Icon.loggedOut, style: .plain, target: StoreViewController.self, action: nil)
	private var observerLargeTitle: NSKeyValueObservation?
	private var topConstraint: NSLayoutConstraint!

	var localEsimsViewController: 		AreasViewController
	var regionalEsimsViewController: 	AreasViewController
	var globalEsimsViewController: 		PackagesViewController
	
	// MARK: - Lifecycle

	init(
		localEsimsViewController: AreasViewController,
		regionalEsimsViewController: AreasViewController,
		globalEsimsViewController: PackagesViewController,
		viewModel: Reactor) {
			self.localEsimsViewController = localEsimsViewController
			self.regionalEsimsViewController = regionalEsimsViewController
			self.globalEsimsViewController = globalEsimsViewController
			super.init(viewModel: viewModel)
			self.reactor = viewModel
	}
	
	override init(viewModel: Reactor) {
		fatalError("Init with propeties must be using")
	}
	
	required init?(coder: NSCoder) {
		fatalError("Init with propeties must be using")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureUI()
	}
		
	// MARK: - Configure
	
	private func configureUI() {
		configureNavbar()
		configureSearchBar()
		configureSegmentedControl(into: view)
	}

	private func configureNavbar() {
		let standardHeight = (self.navigationController?.navigationBar.frame.size.height ?? 0) * 3 + 15
		observerLargeTitle = navigationController?.navigationBar.observe(\.bounds, options: [.new]) { [unowned self] in
			guard let height = $1.newValue?.height else { return }
			self.topConstraint.constant = height > standardHeight ? (height - standardHeight) : 0
			let isSetted = self.navigationItem.rightBarButtonItem != nil
			guard (height > 44 && !isSetted) || (height <= 44 && isSetted) else { return }
			self.navigationItem.setRightBarButton(height > 44 ? self.rightNavButton : nil, animated: true)
		}
		
		let appearance = UINavigationBarAppearance()
		let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 27)]
		let attributesC = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 19)]
		appearance.largeTitleTextAttributes = attributes
		appearance.titleTextAttributes = attributesC
		appearance.shadowColor = nil
		navigationItem.standardAppearance = appearance
		navigationItem.title = C.title
		navigationItem.backBarButtonItem = .init(title: String(), style: .plain, target: nil, action: nil)
		navigationItem.backBarButtonItem?.tintColor = .darkGray

		navigationController?.navigationBar.prefersLargeTitles = true
	}
	
	private func configureSearchBar() {
		navigationItem.searchController = UISearchController()
		navigationItem.searchController?.delegate = self
		navigationItem.searchController?.searchBar.sizeToFit()
		navigationItem.searchController?.searchBar.placeholder = C.searchPlaceholder
		navigationItem.searchController?.searchBar.setFont(.systemFont(ofSize: 13))
		navigationItem.searchController?.searchBar.setImage(Icon.iconSearch, for: .search, state: .normal)
		navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
	}

	private func configureSegmentedControl(into view: UIView) {
		[segmentedControl].forEach(view.addSubview)
		func hideBackground() {
			DispatchQueue.main.async {
				(0...(self.segmentedControl.numberOfSegments-1)).forEach {
					self.segmentedControl.subviews[$0].isHidden = true
				}
		}}
		hideBackground()
		let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)]
		topConstraint = segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
		segmentedControl.setTitleTextAttributes(attributes, for: .normal)
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			topConstraint,
			segmentedControl.leadingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,  constant:  C.offset * 2),
			segmentedControl.trailingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -C.offset * 2),
			segmentedControl.heightAnchor	.constraint(equalToConstant: 28),
		])
		segmentedControl.selectedSegmentIndex = 0
		segmentedControl.sendActions(for: .valueChanged)
	}
	
	override func bind(reactor: StoreViewModel) {
		segmentedControl.rx.selectedSegmentIndex
			.skip(1)
			.subscribe(onNext: { segment in
				switch segment {
					case 1:  self.viewController = self.regionalEsimsViewController
					case 2:  self.viewController = self.globalEsimsViewController
					default: self.viewController = self.localEsimsViewController
				}
			})
			.disposed(by: disposeBag)
	}
}

extension StoreViewController { // MARK: Setting childs
	
	var viewController: UIViewController? {
		get { children.first }
		set { guard let newViewController = newValue else {
				return removeChildViewControllers()
			}
			setChildViewController(newViewController)
		}
	}

	override var preferredStatusBarStyle: UIStatusBarStyle {
		return viewController?.preferredStatusBarStyle ?? .default
	}
	
	private func setChildViewController(_ viewController: UIViewController) {
		removeChildViewControllers()
		viewController.beginAppearanceTransition(true, animated: true)
		addChild(viewController)
		addAndConstrain(viewControllerView: viewController.view)
			viewController.endAppearanceTransition()
		viewController.didMove(toParent: self)
	}
	
	private func removeChildViewControllers() {
		children.forEach { viewController in
			UIView.animate(withDuration: 0.25) { viewController.view.alpha = 0 }
			viewController.beginAppearanceTransition(false, animated: true)
			viewController.willMove(toParent: nil)
			viewController.view.removeFromSuperview()
			viewController.endAppearanceTransition()
			viewController.removeFromParent()
			viewController.didMove(toParent: nil)
		}
	}

	private var isCurrentlyVisible: Bool {
		viewIfLoaded?.window != nil
	}

	private func addAndConstrain(viewControllerView: UIView) {
		viewControllerView.alpha = 0
		view.addSubview(viewControllerView)
		view.sendSubviewToBack(viewControllerView)
		
		viewControllerView.translatesAutoresizingMaskIntoConstraints = false
		let trailingConstraint = viewControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		let bottomConstraint = viewControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		
		NSLayoutConstraint.activate([
			viewControllerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: C.minimalHeight),
			viewControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			viewControllerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
			trailingConstraint,
			bottomConstraint
		])
		viewControllerView.setNeedsLayout()
		UIView.animate(withDuration: 0.25) {
			viewControllerView.alpha = 1
		}
	}
}

extension StoreViewController: UISearchControllerDelegate {}
