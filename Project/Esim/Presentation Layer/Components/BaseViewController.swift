//
//  BaseViewController.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import UIKit

class BaseViewController<Reactor: ESReactor>: UIViewController, ESView {

	// MARK: - Internal properties
	
	var disposeBag = ESDisposeBag()

	// MARK: - Lifecycle
	
	convenience init(viewModel: Reactor) {
		self.init(nibName: nil, bundle: nil)
		reactor = viewModel
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func bind(reactor: Reactor) {
		preconditionFailure("Expecting overriding into subclasses")
	}
}
