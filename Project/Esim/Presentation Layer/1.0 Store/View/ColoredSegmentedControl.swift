//
//  ColoredSegmentedControl.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import UIKit

final class ColoredSegmentedControl: UISegmentedControl {
	
	// MARK: - Lifecycle
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupUI()
	}
	
	override init(items: [Any]?) {
		super.init(items: items)
		setupUI()
	}
	
	required init?(coder: NSCoder) {
		super.init(coder: coder)
		setupUI()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = 4
	}
	
	// MARK: - Public Methods
	
	func configureItems(items: [String] = [String(), String()]) {
		setTitle(items.first, forSegmentAt: 0)
		setTitle(items.last, forSegmentAt: 1)
	}
	
	func clearTitles() {
		configureItems(items: [String(), String()])
	}
	
	// MARK: - Private Methods
	
	private func setupUI() {
		layer.borderWidth = 1
		layer.borderColor = UIColor.clear.cgColor
		selectedSegmentTintColor = .systemGray5
	}
}

private extension UIImage {
	convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
		let rect = CGRect(origin: .zero, size: size)
		UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
		color.setFill()
		UIRectFill(rect)
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		guard let cgImage = image?.cgImage else { return nil }
		self.init(cgImage: cgImage)
	}
}

