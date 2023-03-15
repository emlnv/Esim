//
//  LocalHeaderView.swift
//  Esim
//
//  Created by V on 15.03.2023.
//

import UIKit

final class LocalHeaderView: UITableViewHeaderFooterView {
	
	private let label: UILabel = {
		let label = UILabel()
		label.font = .boldSystemFont(ofSize: 19)
		label.textColor = .label
		label.text = "Popular countries"
		return label
	}()
	
	// MARK: - Init
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		configureUI()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func didMoveToSuperview() {
		clipsToBounds = true
		let size = bounds.size
		let layer = CALayer()
		layer.backgroundColor = UIColor.lightGray.cgColor
		layer.position = CGPointMake(size.width/2, -size.height/2)
		layer.bounds = CGRectMake(0, 0, size.width, size.height)
		layer.shadowColor = UIColor.black.cgColor
		layer.shadowOffset = CGSizeMake(0, 1)
		layer.shadowOpacity = 0.2
		layer.shadowRadius = 20
		self.layer.addSublayer(layer)
	}
	
	// MARK: - Private Methods
	
	private func configureUI() {
		contentView.addSubview(label)
		configureLayout()
	}
	
	private func configureLayout() {
		label.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			label.centerYAnchor	.constraint(equalTo: contentView.centerYAnchor),
			label.leadingAnchor	.constraint(equalTo: contentView.leadingAnchor, constant: 20)
		])
		label.setNeedsLayout()
	}
}
