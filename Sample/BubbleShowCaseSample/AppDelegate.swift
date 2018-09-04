//
//  AppDelegate.swift
//  ShowCaseSample
//
//  Created by Fernando Moya de Rivas on 8/31/18.
//  Copyright © 2018 ElConfidencial. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		window = UIWindow(frame: UIScreen.main.bounds)
		
		let tabBarController = UITabBarController()
		
		let navigationController = UINavigationController()
		navigationController.viewControllers = [ShowCaseViewController()]
		
		var viewControllers: [UIViewController] = [navigationController]
		(1...7).forEach { _ in viewControllers.append(DummyViewController()) }
		
		tabBarController.viewControllers = viewControllers
		
		window?.rootViewController = tabBarController
		window?.makeKeyAndVisible()
		
		return true
	}

}

