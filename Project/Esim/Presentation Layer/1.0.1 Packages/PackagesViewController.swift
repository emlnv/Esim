//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import UIKit

final class PackagesViewController: ESTableViewController<PackagesViewModel> {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(PackagesTableViewCell.self, forCellReuseIdentifier: PackagesTableViewCell.reuseIdentifier)
	}
	
	override func bind(reactor: PackagesViewModel) {
		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getPackagesBy(id: reactor.currentState.selectedCountry.id) }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
			.compactMap (\.packages)
		.debug()
			.distinctUntilChanged()
			.drive(tableView.rx.items(
				cellIdentifier: PackagesTableViewCell.reuseIdentifier,
				cellType: PackagesTableViewCell.self
			)) { _, data, cell in
				cell.configure(package: data)
			}
			.disposed(by: disposeBag)

		reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
			.compactMap { $0.error }
			.drive(onNext: { [weak self] error in
				self?.showOkAlert(
					title: "Error",
					message: error.debugDescription)
			})
			.disposed(by: disposeBag)

		reactor.state
			.map (\.selectedCountry.title)
			.asObservable()
			.bind(to: rx.title)
			.disposed(by: disposeBag)
	}
}
