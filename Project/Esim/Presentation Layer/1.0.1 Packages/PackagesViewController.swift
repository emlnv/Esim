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
		parent?.navigationItem.backBarButtonItem = .init(title: String(), style: .plain, target: nil, action: nil)
	}
	
	override func bind(reactor: PackagesViewModel) {
		let state = reactor.state.asDriver(onErrorJustReturn: reactor.currentState)

		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getPackagesBy(id: reactor.currentState.selectedCountry.id) }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		state
			.compactMap (\.packages)
			.distinctUntilChanged()
			.drive(tableView.rx.items(
				cellIdentifier: PackagesTableViewCell.reuseIdentifier,
				cellType: PackagesTableViewCell.self
			)) { _, data, cell in
				cell.configure(package: data)
			}
			.disposed(by: disposeBag)

		state
			.compactMap { $0.error }
			.drive(onNext: { [weak self] error in
				self?.showOkAlert(title: "Error", message: error.debugDescription)
			})
			.disposed(by: disposeBag)

		state
			.map (\.selectedCountry.title)
			.asObservable()
			.bind(to: rx.title)
			.disposed(by: disposeBag)
		
		state
			.map { $0.isLoading }
			.distinctUntilChanged()
			.drive(onNext: { [weak self] in
				guard let self else { return }
				ActivityIndicatorManager.updateActivityIndicator(forView: self.view, isHidden: !$0)
			})
			.disposed(by: disposeBag)
	}
}
