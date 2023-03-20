//
//  Area.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

struct Package: Decodable, Equatable, Hashable {
	
	init(id: Int? = nil, slug: String? = nil, type: String? = nil, price: Double? = nil, title: String? = nil, data: String? = nil, validity: String? = nil, day: Int? = nil, amount: Int? = nil, is_unlimited: Bool? = nil, note: String? = nil, short_info: String? = nil, is_stock: Bool? = nil, `operator`: Operator? = nil) {
		self.id = id
		self.slug = slug
		self.type = type
		self.price = price
		self.title = title
		self.data = data
		self.validity = validity
		self.day = day
		self.amount = amount
		self.is_unlimited = is_unlimited
		self.note = note
		self.short_info = short_info
		self.is_stock = is_stock
		self.`operator` = `operator`
	}
	
	
	let id: Int?
	let slug: String?
	let type: String?
	let price: Double?
	let title: String?
	let data: String?
	let validity: String?
	let day: Int?
	let amount: Int?
	let is_unlimited: Bool?
	let note: String?
	let short_info: String?
	let is_stock: Bool?
	var `operator`: Operator?
}

struct Operator: Decodable, Equatable, Hashable {
	
	let id: Int?
	let title: String?
	let style: Style?
	let gradient_start: String?
	let gradient_end: String?
	let type: String?
	let is_prepaid: Bool?
	let is_multi_package: Bool?
	let plan_type: String?
	let activation_policy: String?
	let rechargeability: Bool?
	let apn_type: String?
	let apn_type_ios: String?
	let apn_type_android: String?
	let apn_single: String?
	let data_roaming: Bool?
	let airplane_toggle: Bool?
	let image: Flag
	var imageData: Data?
	let countries: [Area]
	
	enum Style: String, Decodable {
		case light, dark
	}
}
