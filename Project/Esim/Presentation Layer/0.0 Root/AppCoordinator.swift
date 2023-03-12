//
//  AppCoordinator.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import Swinject

final class AppCoordinator {
	
	private let assembler = Assembler([
		RootAssembly()
	])
	
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
		assembler.apply(assemblies: [StoreAssembly()])
		let controller = assembler.forceResolve(ESNavigationController.self, name: ESNavigationController.Constants.catalog)
		
		catalogCoordinator = StoreCoordinator(
			assembler: assembler,
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
