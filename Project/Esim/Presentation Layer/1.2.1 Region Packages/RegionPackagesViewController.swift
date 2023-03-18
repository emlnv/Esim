//
//  RegionPackagesViewController.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import UIKit

final class RegionPackagesViewController: ESTableViewController<RegionPackagesViewModel> {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(PackagesOrangeTableViewCell.self, forCellReuseIdentifier: PackagesOrangeTableViewCell.reuseIdentifier)
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
		parent?.navigationItem.backBarButtonItem = .init(title: String(), style: .plain, target: nil, action: nil)
	}
	
	override func bind(reactor: RegionPackagesViewModel) {
		let state = reactor.state.asDriver(onErrorJustReturn: reactor.currentState)
		
		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getPackagesBy(id: reactor.currentState.selectedCountry.id) }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		state
			.compactMap (\.packages)
			.distinctUntilChanged()
			.drive(tableView.rx.items(
				cellIdentifier: PackagesOrangeTableViewCell.reuseIdentifier,
				cellType: PackagesOrangeTableViewCell.self
			)) { _, data, cell in
				cell.configure(package: data)
			}
			.disposed(by: disposeBag)
		
		state
			.compactMap { $0.error }
			.drive(onNext: { [weak self] error in
				self?.showOkAlert(title: "Error", message: error?.localizedDescription)
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

extension RegionPackagesViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		28
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		LocalHeaderView(reuseIdentifier: String(describing: LocalHeaderView.self), needLabel: false)
	}
}
