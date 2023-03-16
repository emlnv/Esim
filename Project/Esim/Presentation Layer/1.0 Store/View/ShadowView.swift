//
//  ShadowView.swift
//  Esim
//
//  Created by Viacheslav on 16.03.2023.
//

import UIKit

final class ShadowView: UIView {
	override var bounds: CGRect {
		didSet {
			setupShadow()
		}
	}
	
	private func setupShadow() {
		layer.shadowOffset = CGSize(width: 0, height: 10/2)
		layer.shadowRadius = 10
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOpacity = 0.25/2
		layer.shadowPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 7, height: 7)).cgPath
		layer.shouldRasterize = true
		layer.rasterizationScale = 0.75
	}
}
