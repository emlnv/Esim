//
//  AppCoordinator.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

final class AppCoordinator {
	
	private let rootViewController: TabBarController
	private var catalogCoordinator: StoreCoordinator?

	init(rootViewController: TabBarController) {
		self.rootViewController = rootViewController
	}
	
	@discardableResult
	func start() -> TabBarController {
		startLoading()
		return rootViewController
	}

	private func startLoading() {
		let catalogMainViewController = startStoreCoordinator()
		let myEsimsMainViewController = startEsimsCoordinator()
		let profileMainViewController = startProfileCoordinator()
		
		rootViewController.viewControllers = [
			catalogMainViewController,
			myEsimsMainViewController,
			profileMainViewController
		]
	}
	
	private func startStoreCoordinator() -> ESNavigationController {
		let controller = ESContainer.shared.navigationViewController
		
		catalogCoordinator = StoreCoordinator(
			navigationController: controller
		)
		catalogCoordinator?.start()
		return controller
	}

	private func startEsimsCoordinator() -> ESNavigationController {
		return ESNavigationController()
	}
	
	private func startProfileCoordinator() -> ESNavigationController {
		return ESNavigationController()
	}
}
