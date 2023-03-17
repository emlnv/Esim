//
//  Country.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

struct Package: Decodable, Equatable {
	
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

struct Operator: Decodable, Equatable {
	
	let id: Int?
	let title: String?
	let style: String?
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
}
