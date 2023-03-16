//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit

final class LocalEsimsViewController: ESTableViewController<LocalEsimsViewModel> {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
		tableView.rx.setDelegate(self).disposed(by: disposeBag)
	}
	
	override func bind(reactor: LocalEsimsViewModel) {
		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getCountriesPopular }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
			.compactMap (\.countriesWithImage)
			.distinctUntilChanged()
			.drive(tableView.rx.items(
				cellIdentifier: CountryTableViewCell.reuseIdentifier,
				cellType: CountryTableViewCell.self
			)) { _, data, cell in
				cell.configure(country: data)
			}
			.disposed(by: disposeBag)
		
		tableView.rx.modelSelected(CountryWithImage.self)
			.map(Reactor.Action.setSelectCountry)
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
	}
}

extension LocalEsimsViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		70
	}
	
	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		LocalHeaderView(reuseIdentifier: String(describing: LocalHeaderView.self))
	}
}
