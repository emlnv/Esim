//
//  RootAssembly.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit

extension ESContainer {
	var storeNavigationViewController: ESNavigationController { nVC.callAsFunction() }
	var myEsimsNavigationViewController: ESNavigationController { nVC2.callAsFunction() }
	var profileNavigationViewController: ESNavigationController { nVC3.callAsFunction() }
	
	private var nVC: ESFactory<ESNavigationController> {
		ESFactory(self) {
			let nVC = ESNavigationController()
			nVC.tabBarItem = UITabBarItem(
				title: nil,
				image: Icon.iconStore,
				tag: TabBarController.TabBarItem.store.rawValue
			)
			return nVC
		}
	}
	
	private var nVC2: ESFactory<ESNavigationController> {
		ESFactory(self) {
			let nVC = ESNavigationController()
			nVC.tabBarItem = UITabBarItem(
				title: nil,
				image: Icon.iconMyEsims,
				tag: TabBarController.TabBarItem.myEsims.rawValue
			)
			return nVC
		}
	}
	
	private var nVC3: ESFactory<ESNavigationController> {
		ESFactory(self) {
			let nVC = ESNavigationController()
			nVC.tabBarItem = UITabBarItem(
				title: nil,
				image: Icon.iconProfile,
				tag: TabBarController.TabBarItem.profile.rawValue
			)
			return nVC
		}
	}
}
