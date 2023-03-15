//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import UIKit

final class PackagesViewController: ESTableViewController<PackagesViewModel> {
	
	override func bind(reactor: PackagesViewModel) {
		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getPackagesBy(id: 0) }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
	}
}
