//
//  Country.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

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
}
