//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit.UITableView

final class RegionalEsimsViewController: ESTableViewController<RegionalEsimsViewModel> {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(AreaTableViewCell.self, forCellReuseIdentifier: AreaTableViewCell.reuseIdentifier)
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
	}
	
	override func bind(reactor: RegionalEsimsViewModel) {
		let state = reactor.state.asDriver(onErrorJustReturn: reactor.currentState)

		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getRegions }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		state
			.compactMap (\.countriesWithImage)
			.distinctUntilChanged()
			.drive(tableView.rx.items(
				cellIdentifier: AreaTableViewCell.reuseIdentifier,
				cellType: AreaTableViewCell.self
			)) { _, data, cell in
				cell.configure(area: data)
			}
			.disposed(by: disposeBag)
		
		tableView.rx.modelSelected(Area.self)
			.map(Reactor.Action.setSelectArea)
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		state
			.map { $0.isLoading }
			.distinctUntilChanged()
			.drive(onNext: { [weak self] in
				guard let self else { return }
				ActivityIndicatorManager.updateActivityIndicator(forView: self.view, isHidden: !$0)
			})
			.disposed(by: disposeBag)
		
		state
			.compactMap { $0.error }
			.drive(onNext: { [weak self] error in
				self?.showOkAlert(title: "Error", message: error.localizedDescription)
			})
			.disposed(by: disposeBag)
	}
}

extension RegionalEsimsViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		70
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		LocalHeaderView(reuseIdentifier: String(describing: LocalHeaderView.self))
	}
}
