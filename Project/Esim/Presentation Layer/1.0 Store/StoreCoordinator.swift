//
//  StoreCoordinator.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import Swinject

final class StoreCoordinator {
	
	private let assembler: Assembler
	private(set) var navigationController: ESNavigationController

	// MARK: - Init
	
	init(
		assembler: Assembler,
		navigationController: ESNavigationController
	) {
		self.assembler = assembler
		self.navigationController = navigationController
	}
	
	func start() {
		let catalogMainViewController = assembler.forceResolve(StoreViewController.self)
		// todo setupBindings()
		navigationController.setViewControllers([catalogMainViewController], animated: false)
	}
	
}
