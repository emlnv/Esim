//
//  RootAssembly.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

extension ESContainer {
	var navigationViewController: ESNavigationController { nVC.callAsFunction() }
	
	private var nVC: ESFactory<ESNavigationController> {
		ESFactory(self) {
			let nVC = ESNavigationController()
			/*
			 nVC.tabBarItem = UITabBarItem(
			 title: nil,
			 image: Icon.iconDisabledScan,
			 tag: TabBarController.TabBarItem.scaner.rawValue
			 )
			 */
			return nVC
		}
	}
}
