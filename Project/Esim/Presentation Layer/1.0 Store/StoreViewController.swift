//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit

final class StoreViewController: BaseViewController<StoreViewModel> {
	
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
	
	private let searchBarView = SearchBarView()
	
	private let segmentedControl = ColoredSegmentedControl(items: [C.titleTab1, C.titleTab2, C.titleTab3])
	
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
		view.addSubview(tableView)
		configureNavbar()
		configureTableView()
	}

	private func configureNavbar() {
		navigationController?.navigationBar.prefersLargeTitles = true
		
		navigationItem.title = C.title
		navigationItem.searchController = UISearchController()
		navigationItem.searchController?.delegate = self // todo
		navigationItem.searchController?.searchBar.sizeToFit()
		navigationItem.searchController?.hidesNavigationBarDuringPresentation = true
		navigationItem.hidesSearchBarWhenScrolling = true
		definesPresentationContext = true
	}
	
	private func configureTableView() {
		[segmentedControl].forEach(view.addSubview)
		configureSegmentedControl(into: view)
		
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.leadingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.topAnchor		.constraint(equalTo: segmentedControl.bottomAnchor),
			tableView.bottomAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
	
	private func configureSearchBar(into view: UIView) {
		searchBarView.configure(placeholder: C.searchPlaceholder)
		
		searchBarView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			searchBarView.leadingAnchor	.constraint(equalTo: view.leadingAnchor, constant: C.offset),
			searchBarView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -C.offset),
			searchBarView.topAnchor		.constraint(equalTo: view.topAnchor),
			searchBarView.heightAnchor	.constraint(equalToConstant: 56)
		])
	}

	private func configureSegmentedControl(into view: UIView) {
		
		segmentedControl.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			segmentedControl.leadingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor,  constant:  C.offset * 2),
			segmentedControl.trailingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -C.offset * 2),
			segmentedControl.topAnchor		.constraint(equalTo: navigationController!.navigationBar.bottomAnchor, constant: C.offset),
			segmentedControl.heightAnchor	.constraint(equalToConstant: 28),
		])
	}
	
	override func bind(reactor: StoreViewModel) {
		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getCountriesPopular }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
		
		reactor.state.asDriver(onErrorJustReturn: reactor.initialState)
			.compactMap (\.countriesPopular)
			.distinctUntilChanged()
			.drive(tableView.rx.items(
				cellIdentifier: CountryTableViewCell.reuseIdentifier,
				cellType: CountryTableViewCell.self
			)) { _, data, cell in
				cell.configure(country: data)
			}
			.disposed(by: disposeBag)
	}
}

extension StoreViewController: UISearchControllerDelegate {}
