//
//  StoreAssembly.swift
//  Esim
//
//  Created by V on 12.03.2023.
//

import Swinject

struct StoreAssembly: Assembly {
	func assemble(container: Container) {
		container.register(StoreViewController.self) { _ in
			let viewController = StoreViewController()
			return viewController
		}
	}
}
