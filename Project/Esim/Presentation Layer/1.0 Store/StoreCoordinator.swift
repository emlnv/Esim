//
//  StoreCoordinator.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

final class StoreCoordinator {
	
	private(set) var navigationController: ESNavigationController

	// MARK: - Init
	
	init(
		navigationController: ESNavigationController
	) {
		self.navigationController = navigationController
	}
	
	func start() {
		let catalogMainViewController = ESContainer.shared.storeViewController
		setupBindings(for: catalogMainViewController)
		navigationController.setViewControllers([catalogMainViewController], animated: false)
	}
	
	private func setupBindings(for viewController: StoreViewController) {
		guard let reactor = viewController.localEsimsViewController.reactor else { return }
		let state = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
				
		state
			.compactMap(\.selectedCountry)
			.drive(onNext: { [weak self] in
				self?.push(selectedCountry: $0)
			})
			.disposed(by: viewController.disposeBag)

	}
	
	private func push(selectedCountry: CountryWithImage) {
		let viewController = ESContainer.shared.packagesViewController
		navigationController.pushViewController(viewController, animated: true)
		viewController.loadViewIfNeeded()
		setupBindings(for: viewController)
	}
	
	private func setupBindings(for viewController: PackagesViewController) {
		guard let reactor = viewController.reactor else { return }
		let state = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
	}
	
}
