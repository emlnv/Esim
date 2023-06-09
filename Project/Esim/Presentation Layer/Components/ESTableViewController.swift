//
//  StoreViewController.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit

class ESTableViewController<Reactor: ESReactor>: ESBaseViewController<Reactor> {
	
	private typealias C = Constants
	private enum Constants {
		static var offset: CGFloat		 { 8 }
		static var margin: CGFloat		 { 20 }
		static var headerHeight: CGFloat { 100 }
	}
	
	private(set) var tableView: UITableView = {
		let tableView = UITableView(frame: .zero, style: .grouped)
		tableView.tableFooterView = .init()
		tableView.separatorInset = .zero
		tableView.separatorStyle = .none
		tableView.keyboardDismissMode = .onDrag
		tableView.backgroundColor = .systemBackground
		if #available(iOS 15.0, *) { tableView.sectionHeaderTopPadding = 0 }
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
}
