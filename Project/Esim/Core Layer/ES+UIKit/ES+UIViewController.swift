//
//  ES+UIViewController.swift
//  Esim
//
//  Created by V on 16.03.2023.
//

import UIKit.UIViewController

extension UIViewController {
	
	func showAlert(title: String?, message: String?, animated: Bool = true, actions: [UIAlertAction]) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		actions.forEach(alertController.addAction)
		present(alertController, animated: animated)
	}
	
	func showOkAlert(title: String?, message: String? = nil, handler: (() -> Void)? = nil) {
		let action = UIAlertAction(title: String("OK"), style: .default, handler: { _ in handler?() })
		showAlert(title: title, message: message, actions: [action])
	}
}
