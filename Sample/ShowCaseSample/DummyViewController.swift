//
//  DummyViewController.swift
//  ShowCaseSample
//
//  Created by Fernando Moya de Rivas on 8/31/18.
//  Copyright © 2018 ElConfidencial. All rights reserved.
//

import UIKit

class DummyViewController: UIViewController {
	
	private static var index = 1
	private var icons: [UITabBarSystemItem] = [UITabBarSystemItem.bookmarks, UITabBarSystemItem.contacts, UITabBarSystemItem.favorites, UITabBarSystemItem.downloads, UITabBarSystemItem.history, UITabBarSystemItem.search]
	
	init() {
		super.init(nibName: nil, bundle: nil)
		
		let index = DummyViewController.index >= icons.count ? icons.count - 1 : DummyViewController.index
		let icon = icons[index]
		self.tabBarItem = UITabBarItem(tabBarSystemItem: icon, tag: index)
		DummyViewController.index = index + 1
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
