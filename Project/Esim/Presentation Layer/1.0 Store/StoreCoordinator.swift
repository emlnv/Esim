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
		// todo setupBindings()
		navigationController.setViewControllers([catalogMainViewController], animated: false)
	}
}
