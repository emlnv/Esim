//
//  TabBarController.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit.UIViewController

final class TabBarController: UITabBarController {
	
	enum TabBarItem: Int {
		case store
		case myEsims
		case profile
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		tabBar.tintColor = .systemGray3
	}
}
