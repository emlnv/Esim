//
//  BaseViewController.swift
//  Esim
//
//  Created by Viacheslav on 14.03.2023.
//

import UIKit

class ESBaseViewController<Reactor: ESReactor>: UIViewController, ESView {

	// MARK: - Internal properties
	
	var disposeBag = ESDisposeBag()

	// MARK: - Lifecycle
	
	init(viewModel: Reactor) {
		super.init(nibName: nil, bundle: nil)
		reactor = viewModel
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	func bind(reactor: Reactor) {
		preconditionFailure("Expecting overriding into subclasses")
	}
}
