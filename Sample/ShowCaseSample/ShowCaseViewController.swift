//
//  showCaseController.swift
//  ShowCaseSample
//
//  Created by Fernando Moya de Rivas on 8/31/18.
//  Copyright © 2018 ElConfidencial. All rights reserved.
//

import UIKit

class ShowCaseViewController: UIViewController {

	@IBOutlet weak var startDemoButton: UIButton! {
		didSet {
			startDemoButton.layer.masksToBounds = true
			startDemoButton.layer.cornerRadius = 4.0
			startDemoButton.layer.borderColor = startDemoButton.titleColor(for: .normal)?.cgColor
			startDemoButton.layer.borderWidth = 2.0
		}
	}
	
	@IBOutlet weak var tableView: UITableView! {
		didSet {
			tableView.dataSource = self
			tableView.delegate = self
		}
	}
	
	private var isCellShowCaseShown = false
	
	init() {
		super.init(nibName: nil, bundle: nil)
		self.tabBarItem = UITabBarItem(tabBarSystemItem: .mostViewed, tag: 0)
		
		let imageView = UIImageView(image: UIImage(named: "icon-write-comment"))
		let barButtonItem = UIBarButtonItem(customView: imageView)
		
		self.navigationItem.rightBarButtonItem = barButtonItem
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc private func cameraDidTap() {
		showSimpleAlert(title: "You tapped the camera icon", message: "Something marvelous is bound to happen")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Show Case Sample"
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		let showCaseOnView = ShowCase(target: startDemoButton, arrowDirection: .down, label: "startDemoButton")
		showCaseOnView.titleText = "Tap here to close it"
		showCaseOnView.descriptionText = "You will start the demo"
		showCaseOnView.arrowDirection = .right
		showCaseOnView.shadowColor = startDemoButton.titleColor(for: .normal)
		showCaseOnView.isCrossDismissable = false
		showCaseOnView.delegate = self
		
		showCaseOnView.show()
	}
	
	@IBAction func startDemoDidTap(_ sender: UIButton) {

		let showCaseOnTabBar = ShowCase(tabBar: tabBarController!.tabBar, index: 8, label: "tabBar")
		showCaseOnTabBar.titleText = "In a tabBar!"
		showCaseOnTabBar.descriptionText = "It doesn't matter wether the item is hidden"
		showCaseOnTabBar.color = UIColor(red: 196.0/255.0, green: 249.0/255.0, blue: 212.0/255.0, alpha: 1.0)
		showCaseOnTabBar.textColor = UIColor.darkGray
		showCaseOnTabBar.delegate = self
		
		let showCaseOnNavBar = ShowCase(target: navigationItem.rightBarButtonItem!, label: "barButtonItem")!
		showCaseOnNavBar.titleText = "Watch out!"
		showCaseOnNavBar.descriptionText = "Bar buttons must be custom so that the show case works"
		showCaseOnTabBar.concat(showCase: showCaseOnNavBar)
		showCaseOnNavBar.color = UIColor(red: 255.0/255.0, green: 26.0/255.0, blue: 114.0/255.0, alpha: 1.0)
		showCaseOnNavBar.shadowColor = UIColor.blue
		showCaseOnNavBar.textColor = UIColor.white
		
		let showCaseOnRootView = ShowCase(target: view, arrowDirection: .upAndDown, label: "rootView")
		showCaseOnRootView.titleText = "Lots of directions"
		showCaseOnRootView.delegate = self
		showCaseOnRootView.image = UIImage(named: "show-case-swipe")
		showCaseOnRootView.descriptionText = "-Double directions are placed in the center of the screen \n-You can add images too \n-Show a cross to dismiss it or choose to force the user to react to the target"
		showCaseOnNavBar.concat(showCase: showCaseOnRootView)
		
		DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100)) { [weak self] in
			guard let `self` = self else { return }
			if let cell = self.tableView.cellForRow(at: IndexPath(row: 4, section: 0)) {
				let showCaseOnCell = ShowCase(cell: cell, target: nil, arrowDirection: .down, label: "cellIndex4")
				showCaseOnCell.titleText = "Hey, what about me?"
				showCaseOnCell.descriptionText = "ShowCase works also for both UITableView and UICollectionView"
				showCaseOnCell.delegate = self
				showCaseOnCell.shadowColor = UIColor.black
				showCaseOnCell.color = UIColor(red: 235.0/255.0, green: 213.0/255.0, blue: 64.0/255.0, alpha: 1.0)
				showCaseOnCell.textColor = UIColor.darkGray
				
				showCaseOnCell.show(after: showCaseOnRootView)
			}
		}
		
		showCaseOnTabBar.show()
	}
	
}

extension ShowCaseViewController: ShowCaseDelegate {

	func showCase(_ showCase: ShowCase, didTap target: UIView!, gestureRecognizer: UITapGestureRecognizer) {
		if showCase.label == "startDemoButton" {
			showSimpleAlert(title: "Hey!", message: "You can react to certain gestures. See ShowCaseDelegate for more information.") { [weak self] in
				guard let `self` = self else { return }
				self.startDemoDidTap(self.startDemoButton)
			}
			
			showCase.dimiss()
		}
	}
	
}

extension ShowCaseViewController: UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return 16
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell: UITableViewCell
		if let cellUnwrapped = tableView.dequeueReusableCell(withIdentifier: "ShowCaseCellIdentifier") {
			cell = cellUnwrapped
		} else {
			cell = UITableViewCell(style: .default, reuseIdentifier: "ShowCaseCellIdentifier")
		}
		cell.textLabel?.text = "Item \(indexPath.row)"
		cell.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.lightGray
		return cell
	}
	
}

extension ShowCaseViewController: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == 12, !isCellShowCaseShown {
			let showCaseOnCell = ShowCase(cell: cell, target: nil, arrowDirection: .down, label: "cellIndex12")
			showCaseOnCell.titleText = "Am I not in the screen?"
			showCaseOnCell.descriptionText = "I'll stop the scroll and make sure the cell displays"
			showCaseOnCell.delegate = self
			showCaseOnCell.shadowColor = nil
			
			showCaseOnCell.show()
			isCellShowCaseShown = true
		}
	}
}

extension UIViewController {
	
	func showSimpleAlert(title: String, message: String, action: (() -> Void)? = nil) {
		let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
		let okAction = UIAlertAction(title: "Gotcha", style: .default) { _ in
			action?()
		}
		alertController.addAction(okAction)
		present(alertController, animated: true)
	}
	
}
