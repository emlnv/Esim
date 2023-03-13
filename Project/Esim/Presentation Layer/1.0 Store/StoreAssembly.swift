//
//  StoreAssembly.swift
//  Esim
//
//  Created by V on 12.03.2023.
//

extension ESContainer {
	var storeViewController: StoreViewController { storeVC.callAsFunction() }
	
	private var storeVC: ESFactory<StoreViewController> {
		ESFactory(self) { StoreViewController() }
	}
}
