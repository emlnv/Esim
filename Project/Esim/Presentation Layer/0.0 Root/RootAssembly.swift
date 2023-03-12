//
//  RootAssembly.swift
//  Esim
//
//  Created by V on 12.03.2023.
//

import Swinject

struct RootAssembly: Assembly {
	
	func assemble(container: Container) {
		container.register(ESNavigationController.self, name: ESNavigationController.Constants.catalog) { _ in
			let navigationController = ESNavigationController()
			/*
			 navigationController.tabBarItem = UITabBarItem(
				title: nil,
				image: Icon.iconDisabledScan,
				tag: TabBarController.TabBarItem.scaner.rawValue
			)
			*/
			return navigationController
		}
		
	}
}

