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
		static let searchPlaceholder = "Search data packs for +190 countries and reg…"
		static let offset: CGFloat = 8
		static var offsetTop: CGFloat = 50
	}
	
	private let searchBarView = SearchBarView()
	private let segmentedControl = ColoredSegmentedControl(items: [C.titleTab1, C.titleTab2, C.titleTab3])
	
	var localEsimsViewController: LocalEsimsViewController
	var regionalEsimsViewController: UIViewController
	
	// MARK: - Lifecycle

	init(
		localEsimsViewController: LocalEsimsViewController,
		regionalEsimsViewController: UIViewController,
		viewModel: Reactor) {
			self.localEsimsViewController = localEsimsViewController
			self.regionalEsimsViewController = regionalEsimsViewController
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
		setChildViewController(localEsimsViewController)
	}
	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		configureUI()
	}
	
	// MARK: - Configure
	
	private func configureUI() {
		[segmentedControl].forEach(view.addSubview)
		configureSegmentedControl(into: view)
		configureNavbar()
	}

	private func configureNavbar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.title = C.title
		navigationItem.searchController = UISearchController()
		navigationItem.searchController?.delegate = self // todo
		navigationItem.searchController?.searchBar.sizeToFit()
		navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
		navigationItem.hidesSearchBarWhenScrolling = true
		definesPresentationContext = true
	}
	
	private func configureSearchBar(into view: UIView) {
		searchBarView.configure(placeholder: C.searchPlaceholder)
		
		searchBarView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			searchBarView.leadingAnchor	.constraint(equalTo: view.leadingAnchor,  constant:  C.offset),
			searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.offset),
			searchBarView.topAnchor		.constraint(equalTo: view.topAnchor),
			searchBarView.heightAnchor	.constraint(equalToConstant: 56)
		])
	}

	private func configureSegmentedControl(into view: UIView) {
		
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			segmentedControl.leadingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,  constant:  C.offset * 2),
			segmentedControl.trailingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -C.offset * 2),
			segmentedControl.topAnchor		.constraint(equalTo: navigationController!.navigationBar.bottomAnchor, constant: C.offset),
			segmentedControl.heightAnchor	.constraint(equalToConstant: 28),
		])
	}
	
	override func bind(reactor: StoreViewModel) {
		/*
		 segmentedControl.rx.selectedSegmentIndex
			.map { _ in Reactor.Action.switchTab }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		*/
	}
}

extension StoreViewController {
	
	// MARK: Setting childs
	
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
		addChild(viewController)
		addAndConstrain(viewControllerView: viewController.view)
		if isCurrentlyVisible {
			viewController.beginAppearanceTransition(true, animated: false)
			viewController.endAppearanceTransition()
		}
		viewController.didMove(toParent: self)
	}
	
	private func removeChildViewControllers() {
		children.forEach { viewController in
			viewController.willMove(toParent: nil)
			if isCurrentlyVisible {
				viewController.beginAppearanceTransition(false, animated: false)
				viewController.endAppearanceTransition()
			}
			viewController.view.removeFromSuperview()
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
			trailingConstraint,
			bottomConstraint
		])
		viewControllerView.setNeedsLayout()
	}

	private func dissolveTransition(to viewController: UIViewController) {
		guard let previousViewController = children.first else {
			return setChildViewController(viewController)
		}
		addChild(viewController)
		previousViewController.willMove(toParent: nil)
		addAndConstrain(viewControllerView: viewController.view)
		previousViewController.beginAppearanceTransition(false, animated: true)
		viewController.beginAppearanceTransition(true, animated: true)

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
