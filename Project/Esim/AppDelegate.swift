//
//  AppDelegate.swift
//  Esim
//
//  Created by Viacheslav on 12.03.2023.
//

import UIKit.UIWindow

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	private let appCoordinator = AppCoordinator(rootViewController: TabBarController())

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		configureWindow()
		configureFonts()
		return true
	}
	
	private func configureWindow() {
		window = UIWindow()
		window?.backgroundColor = .systemBackground
		window?.rootViewController = appCoordinator.start()
		window?.makeKeyAndVisible()
	}
	
	private func configureFonts() {
		UIFont.overrideInitialize()
	}
}
