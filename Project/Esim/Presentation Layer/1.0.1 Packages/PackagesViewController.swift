//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import UIKit

final class PackagesViewController: BaseViewController<PackagesViewModel> {
	
	private typealias C = Constants
	private enum Constants {
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
		view.addSubview(tableView)
		configureNavbar()
		configureTableView()
	}
	
	private func configureNavbar() {
	}
	
	private func configureTableView() {
		tableView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			tableView.leadingAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
			tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
			tableView.topAnchor		.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
			tableView.bottomAnchor	.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
		])
	}
		
	override func bind(reactor: PackagesViewModel) {
		rx.methodInvoked(#selector(viewDidLoad))
			.map { _ in Reactor.Action.getPackagesBy(id: 0) }
			.bind(to: reactor.action)
			.disposed(by: disposeBag)
	}
}
