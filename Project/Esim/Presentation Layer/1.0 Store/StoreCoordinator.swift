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
		let stateL = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
				
		stateL
			.compactMap(\.selectedCountry)
			.drive(onNext: { [weak self] in
				self?.push(selectedCountry: $0)
			})
			.disposed(by: viewController.disposeBag)

		guard let reactor = viewController.regionalEsimsViewController.reactor else { return }
		let stateR = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
				
		stateR
			.compactMap(\.selectedCountry)
			.drive(onNext: { [weak self] in
				self?.push(selectedRegion: $0)
			})
			.disposed(by: viewController.disposeBag)

	}
	
	private func push(selectedCountry: Country) {
		let viewController = ESContainer.shared.packagesViewController(for: selectedCountry)
		navigationController.pushViewController(viewController, animated: true)
		viewController.loadViewIfNeeded()
		setupBindings(for: viewController)
	}
	
	private func push(selectedRegion: Country) {
		let viewController = ESContainer.shared.regionPackagesViewController(for: selectedRegion)
		navigationController.pushViewController(viewController, animated: true)
		viewController.loadViewIfNeeded()
	}
	
	private func setupBindings(for viewController: PackagesViewController) {
		guard let reactor = viewController.reactor else { return }
		let _ = reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
	}
	
}
