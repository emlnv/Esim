//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit

final class LocalEsimsViewController: BaseViewController<LocalEsimsViewModel> {
	
	private typealias C = Constants
	private enum Constants {
		static let title = "Hello"
		static let titleTab1 = "Local eSIMs"
		static let titleTab2 = "Regional eSIMs"
		static let titleTab3 = "Global eSIMs"
		static let searchPlaceholder = "Search data packs for +190 countries and reg…"
		static let offset: CGFloat = 8
		static let headerHeight: CGFloat = 100
	}
	
	private var tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
		tableView.tableFooterView = .init()
		tableView.separatorInset = .zero
		tableView.keyboardDismissMode = .onDrag
		return tableView
	}()

	// MARK: - Lifecycle
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		configureUI()
	}
	
	// MARK: - Configure
	
	private func configureUI() {
		[tableView].forEach(view.addSubview)
		configureTableView()
	}

	private func configureTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.leadingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.topAnchor		.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
			tableView.bottomAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
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
