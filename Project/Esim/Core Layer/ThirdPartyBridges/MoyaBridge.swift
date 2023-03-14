//
//  MoyaBridge.swift
//  Esim
//
//  Created by Viacheslav on 13.03.2023.
//

import Moya
import RxMoya
import Foundation
import RxSwift

typealias ESMoyaProvider = MoyaProvider
typealias ESNetworkLoggerPlugin = NetworkLoggerPlugin
typealias ESTargetType = TargetType
typealias ESMethod = Moya.Method
typealias ESTask = Moya.Task
typealias ESURLEncoding = Moya.URLEncoding

extension PrimitiveSequence where Trait == SingleTrait, Element == Response {
	func esMap<D: Decodable>(_ type: D.Type, atKeyPath keyPath: String? = nil, using decoder: JSONDecoder = JSONDecoder(), failsOnEmptyData: Bool = true) -> Single<D> {
		flatMap { .just(try $0.map(type, atKeyPath: keyPath, using: decoder, failsOnEmptyData: failsOnEmptyData)) }
	}
}
