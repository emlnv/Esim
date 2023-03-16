//
//  ActivityIndicatorManager.swift
//  Esim
//
//  Created by Viacheslav on 16.03.2023.
//

import  UIKit

final class ActivityIndicatorManager {
	
	class func updateActivityIndicator(forView view: UIView, isHidden: Bool) {
		if let activityIndicatorWindow = UIApplication.shared.windows
			.first(where: { $0.subviews.contains(where: { $0 is UIActivityIndicatorView }) }),
		   let activityIndicator = activityIndicatorWindow.subviews
			.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
			activityIndicator.stopAnimating()
			activityIndicator.removeFromSuperview()
		}
		guard let vc = UIApplication.shared.windows.filter(\.isKeyWindow).first, !isHidden else { return }
		let activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.layer.cornerRadius = 20
		activityIndicator.startAnimating()
		activityIndicator.frame = .init(x: 0, y: 0, width: 100, height: 100)
		activityIndicator.frame.origin = .init(x: UIScreen.main.bounds.width/2 - 50, y: UIScreen.main.bounds.height/2 - 50)
		activityIndicator.backgroundColor = UIColor.systemGray.withAlphaComponent(0.25)
		vc.addSubview(activityIndicator)
	}
}
