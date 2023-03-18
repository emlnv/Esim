//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import UIKit

final class GlobalEsimsViewController: ESTableViewController<GlobalEsimsViewModel> {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(PackagesBlueTableViewCell.self, forCellReuseIdentifier: PackagesBlueTableViewCell.reuseIdentifier)
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
		parent?.navigationItem.backBarButtonItem = .init(title: String(), style: .plain, target: nil, action: nil)
	}
	
	override func bind(reactor: GlobalEsimsViewModel) {
		let state = reactor.state.asDriver(onErrorJustReturn: reactor.currentState)
		
		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getGlobalPackages }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		state
			.compactMap (\.packages)
			.distinctUntilChanged()
			.drive(tableView.rx.items(
				cellIdentifier: PackagesBlueTableViewCell.reuseIdentifier,
				cellType: PackagesBlueTableViewCell.self
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
			.map { $0.isLoading }
			.distinctUntilChanged()
			.drive(onNext: { [weak self] in
				guard let self else { return }
				ActivityIndicatorManager.updateActivityIndicator(forView: self.view, isHidden: !$0)
			})
			.disposed(by: disposeBag)
	}
}

extension GlobalEsimsViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		28
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		LocalHeaderView(reuseIdentifier: String(describing: LocalHeaderView.self), needLabel: false)
	}
}
