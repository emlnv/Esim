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
		static var headerHeight: CGFloat { 100 }
	}
	
	private(set) var tableView: UITableView = {
		let tableView = UITableView()
		tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: CountryTableViewCell.reuseIdentifier)
		tableView.tableFooterView = .init()
		tableView.separatorInset = .zero
		tableView.keyboardDismissMode = .onDrag
		return tableView
	}()

	// MARK: - Lifecycle
	
	override func loadView() {
		view = tableView
	}
}
