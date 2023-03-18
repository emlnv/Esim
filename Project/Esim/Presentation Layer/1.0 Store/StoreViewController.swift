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
		static var offsetTop: CGFloat = 50
	}
	
	private var searchBarView: SearchBarView!
	private let segmentedControl = ColoredSegmentedControl(items: [C.titleTab1, C.titleTab2, C.titleTab3])
	
	private let rightNavButton = UIBarButtonItem(image: Icon.loggedOut, style: .plain, target: StoreViewController.self, action: nil)
	private var observerLargeTitle: NSKeyValueObservation?

	var localEsimsViewController: 		LocalEsimsViewController
	var regionalEsimsViewController: 	RegionalEsimsViewController
	var globalEsimsViewController: 		GlobalEsimsViewController
	
	// MARK: - Lifecycle

	init(
		localEsimsViewController: LocalEsimsViewController,
		regionalEsimsViewController: RegionalEsimsViewController,
		globalEsimsViewController: GlobalEsimsViewController,
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
		observerLargeTitle = navigationController?.navigationBar.observe(\.bounds, options: [.new]) {
			let isSetted = self.navigationItem.rightBarButtonItem != nil
			guard let height = $1.newValue?.height,
			(height > 44 && !isSetted) || (height <= 44 && isSetted) else { return }
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
		navigationItem.hidesSearchBarWhenScrolling = true
		definesPresentationContext = true
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
		segmentedControl.setTitleTextAttributes(attributes, for: .normal)
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			segmentedControl.leadingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,  constant:  C.offset * 2),
			segmentedControl.trailingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -C.offset * 2),
			segmentedControl.topAnchor		.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: C.offset),
			segmentedControl.heightAnchor	.constraint(equalToConstant: 28),
		])
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

extension StoreViewController {
	
	// MARK: Setting childs
	
	var viewController: UIViewController? {
		get { children.first }
		set { guard let newViewController = newValue else {
				return removeChildViewControllers()
			}
			dissolveTransition(to: newViewController)
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
			viewController.beginAppearanceTransition(false, animated: true)
			viewController.willMove(toParent: nil)
			viewController.view.removeFromSuperview()
			viewController.endAppearanceTransition()
			viewController.removeFromParent()
		}
	}

	private var isCurrentlyVisible: Bool {
		viewIfLoaded?.window != nil
	}

	private func addAndConstrain(viewControllerView: UIView) {
		view.addSubview(viewControllerView)
		view.sendSubviewToBack(viewControllerView)
		viewControllerView.translatesAutoresizingMaskIntoConstraints = false
		let trailingConstraint = viewControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		let bottomConstraint = viewControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
		trailingConstraint.priority = .required - 1	 // To avoid conflicts during initial layout calculations
		bottomConstraint.priority = .required - 1
		NSLayoutConstraint.activate([
			viewControllerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: C.offsetTop),
			viewControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			viewControllerView.heightAnchor.constraint(greaterThanOrEqualToConstant: 1),
			trailingConstraint,
			bottomConstraint
		])
		viewControllerView.setNeedsLayout()
	}

	private func dissolveTransition(to viewController: UIViewController) {
		guard let previousViewController = children.first, previousViewController != viewController else {
			return setChildViewController(viewController)
		}
		addChild(viewController)
		previousViewController.willMove(toParent: nil)
		viewController.beginAppearanceTransition(true, animated: true)
		addAndConstrain(viewControllerView: viewController.view)
		previousViewController.beginAppearanceTransition(false, animated: true)

		UIView.transition(
			from: previousViewController.view,
			to: viewController.view,
			duration: 0.25,
			options: [
				.transitionCrossDissolve,
				.beginFromCurrentState,
				.allowAnimatedContent
			]
		) { completed in
			previousViewController.endAppearanceTransition()
			previousViewController.removeFromParent()
			viewController.endAppearanceTransition()
			viewController.didMove(toParent: self)
		}
	}

}

extension StoreViewController: UISearchControllerDelegate {}
