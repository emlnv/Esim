//
//  EsimTarget.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Foundation

enum EsimTarget: ESTargetType {
	case getPopularCoutries
	case getPackagesForCountry(Int)
	case getGlobalPackages
	case getImage(URL)
	case getRegions
	
	var baseURL: URL {
		switch self {
			case .getPopularCoutries, .getPackagesForCountry, .getRegions, .getGlobalPackages:
				return URL(string: "https://www.airalo.com")! // swiftlint:disable:this force_unwrapping
			case .getImage(let url): return url
		}
	}
	
	var path: String {
		switch self {
			case .getPopularCoutries:
				return "/api/v2/countries"
			case .getImage:
				return String()
			case .getPackagesForCountry(let id):
				return "/api/v2/countries/" + String(id)
			case .getRegions:
				return "/api/v2/regions"
			case .getGlobalPackages:
				return "/api/v2/regions/world"
		}
	}
	
	var method: ESMethod {
		switch self {
			case .getPopularCoutries, .getImage, .getPackagesForCountry, .getRegions, .getGlobalPackages:
				return .get
		}
	}
	
	var sampleData: Data {
		return Data()
	}
	
	var task: ESTask {
		switch self {
			case .getPopularCoutries:
				let parameters: [String: Any] = [
					"type": "popular"
				]
				return .requestParameters(parameters: parameters, encoding: ESURLEncoding.default)
			case .getImage, .getRegions:
				return .requestPlain
			case .getPackagesForCountry(let id):
				let parameters: [String: Any] = [
					"id": id
				]
				return .requestParameters(parameters: parameters, encoding: ESURLEncoding.default)
			case .getGlobalPackages:
				let parameters: [String: Any] = [
					"id": "world"
				]
				return .requestParameters(parameters: parameters, encoding: ESURLEncoding.default)
		}
	}
	
	var headers: [String : String]? {
		switch self {
			case .getPopularCoutries, .getPackagesForCountry, .getRegions, .getGlobalPackages:
				return [
					"Content-Type": "application/json",
					"Accept-Language": "us-US;q=1.0"
				]
			case .getImage: return nil
		}
	}
	
}
