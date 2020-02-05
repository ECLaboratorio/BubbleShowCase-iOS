//
//  BubbleShowCase.swift
//  Angela
//
//  Created by fermoya on 8/13/18.
//  Copyright © 2018 ElConfidencial. All rights reserved.
//
import UIKit
import QuartzCore

/**
The delegate of BubbleShowCase must adopt the BubbleShowCaseDelegate protocol. Optional methods let the delegate know when the show case appears and dismisses and when some of the most common gestures are recognized by the target.
*/
@objc public protocol BubbleShowCaseDelegate: class {
    
    /// Tells the delegate that the user wants to skip the whole thing
    @objc optional func bubbleShowCaseWillSkipTutorial()
    
    /// Tells the delegate the show case is going to appear into the screen
    @objc optional func bubbleShowCaseWillTransitionIntoScreen(_ bubbleShowCase: BubbleShowCase)
    
    /// Tells the delegate appeared into the screen
    @objc optional func bubbleShowCaseDidTransitionIntoScreen(_ bubbleShowCase: BubbleShowCase)
    
    /// Tells the delegate the show case is going to be removed from the screen
    @objc optional func bubbleShowCaseWillDismiss(_ bubbleShowCase: BubbleShowCase)
    
    /// Tells the delegate the show case was removed from the screen
    @objc optional func bubbleShowCaseDidDismiss(_ bubbleShowCase: BubbleShowCase)
    
    /// Tells the delegate the target was tapped
    @objc optional func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didTap target: UIView!, gestureRecognizer: UITapGestureRecognizer)
    
    /// Tells the delegate the target was double tapped
    @objc optional func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didDoubleTap target: UIView!, gestureRecognizer: UITapGestureRecognizer)
    
    /// Tells the delegate the target was swiped leftwards
    @objc optional func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didSwipeLeft target: UIView!, gestureRecognizer: UISwipeGestureRecognizer)
    
    /// Tells the delegate the target was swiped rightwards
    @objc optional func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didSwipeRight target: UIView!, gestureRecognizer: UISwipeGestureRecognizer)
    
    /// Tells the delegate the target was swiped upwards
    @objc optional func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didSwipeUp target: UIView!, gestureRecognizer: UISwipeGestureRecognizer)
    
    /// Tells the delegate the target was swiped downwards
    @objc optional func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didSwipeDown target: UIView!, gestureRecognizer: UISwipeGestureRecognizer)
    
    /// Tells the delegate the target was long pressed
    @objc optional func bubbleShowCase(_ bubbleShowCase: BubbleShowCase, didLongPress target: UIView!, gestureRecognizer: UILongPressGestureRecognizer)
}

/**
A view which inteds to explain some feature of the scene it's shown in by displaying a message that points to a target view.
This so called show case obscurs the scene, pops up above any other view in the screen highlights and animates the target view to catch the user's attention.
# Example #
````
...
let showCase = BubbleShowCaseShow(target: myBarButton, label: "BarButtonShowCase")
showCase.titleText = "You know what?"
showCase.descriptionText = "You can do amazing things if you tap on this navbar button"
showCase.image = UIImage(named: "show-case-bar-button")
showCase.show()
...
// Et voilà....
````
*/
public class BubbleShowCase: UIView {
    
    /**
    It indicates the direction the show case should point to. There are 7 options:
    - Left
    - Right
    - Up
    - Down
    - Up and Down
    - Left and right
    - None
    */
    public enum ArrowDirection {
        /// It points leftwards, making the show case stays on the right side of the target.
        case left
        
        /// It points rightwards, making the show case stays on the left side of the target.
        case right
        
        /// It points upwards, making the show case stays below the target.
        case up
        
        /// It points downwards, making the show case stays above of the target.
        case down
        
        /// It displays to arrows pointing upwards and downwards respectively. The show case pops up centered in the target.
        case upAndDown
        
        /// It displays to arrows pointing leftwards and rightwards respectively. The show case pops up centered in the target.
        case leftAndRight
        
        /// No arrow is displayed
        case none
    }
    
    //MARK: Public properties
    
    /// Background color of the show case.
    public var color = UIColor(red: 18.0 / 255.0, green: 156.0 / 255.0, blue: 226.0 / 255.0, alpha: 1) { didSet { setNeedsDisplay() } }
    
    /// Text color of both the title and description.
    public var textColor = UIColor.white { didSet { setNeedsDisplay() } }
    
    /// Blurred shadow color around the screenshot. If *nil*, it doesn't display any shadow.
    public var shadowColor: UIColor? = UIColor.white { didSet { setNeedsDisplay() } }
    
    /// Color of the cross on the top right of the show case. If not set, it takes the same color of the text.
    public var crossColor: UIColor? { didSet { setNeedsDisplay() } }
    
    /**
    Image set on the left side of the show case.
    
    - Remark: Its size is forced to be 50x50.
    */
    public var image: UIImage? {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// Text displayed as the show case title.
    public var titleText = "" {
        didSet {
            titleLabel?.text = titleText
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    
    /// Text displayed as the show case title.
    public var skipButtonText: String? {
        didSet {
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// Font for the title label.
    public var titleFont: UIFont = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold) {
        didSet {
            titleLabel?.font = titleFont
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// Font for the description label.
    public var descriptionFont: UIFont = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular) {
        didSet {
            descriptionLabel?.font = descriptionFont
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// Text displayed as the show case description.
    public var descriptionText = "" {
        didSet {
            descriptionLabel?.text = descriptionText
            setNeedsLayout()
            setNeedsDisplay()
        }
    }
    
    /// screenshot container bckgroundcolor
    public var sreenshotContainerBackground: UIColor = UIColor.white
    
    /// Time in seconds that it takes to complete the entry animation
    public var showAnimationDuration: Double = 0.4
    
    /// Time in seconds that it takes to complete the exit animation
    public var dismissAnimationDuration: Double = 0.4
    
    /// Time in seconds that it takes to complete one screenshot flicker
    public var flickerAnimationDuration: Double = 0.4
    
    /// Indicates wether or not the user can close the show case by tapping a cross that is displayed on the top right. Set this property to *false* this to force the user to perform any action on the target.
    public var isCrossDismissable = true { didSet { cross?.isHidden = !isCrossDismissable } }
    
    /// The object that acts as the delegate of a Show Case. The delegate is not retained and is therefore qualified as *weak*.
    public weak var delegate: BubbleShowCaseDelegate?
    
    /**
    Direction of the arrow the show case points to. There are 6 possible values.
    
    - Remark: You must ensure the show case will fit on that size
    */
    public var arrowDirection: ArrowDirection { didSet { setNeedsDisplay() } }
    
    /// It serves as the show case identifier
    public private(set) var label: String?
    
    //MARK: Private properties
    
    /**************** SUBVIEWS ********************/
    private var icon: UIImageView? { didSet { icon?.layer.cornerRadius = imageSize.height / 2 } }
    private var titleLabel: UILabel!
    private var descriptionLabel: UILabel!
    private var screenshotContainer: UIView!
    private var bubble: UIView!
    private var skipLabel: UILabel!
    private var cross: UIButton!
    private var arrow: UIView!
    
    /**************** GEOMETRY ********************/
    private var imageSize = CGSize(width: 50, height: 50)
    private var crossSize: CGFloat = 12
    private var crossPadding: CGFloat = 10
    private var crossArea: CGFloat { return 2 * crossPadding + crossSize }
    private var arrowSize: CGFloat = 10
    private var bubblePadding: UIEdgeInsets { return UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 0) }
    private var padding: CGFloat { return arrowSize }
    private var margins: CGFloat = 10
    private var safeAreaMargins: UIEdgeInsets {
        if #available(iOS 11, *) {
            return screenWindow.safeAreaInsets
        } else {
            return UIEdgeInsets.zero
        }
    }
    
    /*************** CONSTRAINTS ******************/
    private var descriptionLeading: NSLayoutConstraint!
    private var sideShowCaseCenterY: NSLayoutConstraint?
    private var sideShowCaseTop: NSLayoutConstraint?
    private var sideShowCaseBottom: NSLayoutConstraint?
    
    private var screenshotTop: NSLayoutConstraint!
    private var screenshotHeight: NSLayoutConstraint!
    private var screenshotWidth: NSLayoutConstraint!
    private var screenshotLeading: NSLayoutConstraint!
    
    private var bubbleLeading: NSLayoutConstraint?
    private var bubbleTrailing: NSLayoutConstraint?
    
    /****************** FLAGS *********************/
    private var shouldWhitenScreenshot = false
    private var isInitialized = false
    private var isBarButton = false
    
    /************* ROOT HIERARCHY *****************/
    private weak var target: UIView!
    private weak var scrollView: UIScrollView?
    private var screenWindow: UIWindow { return UIApplication.shared.keyWindow! }
    
    /***************** LAYERS *********************/
    private var crossLayer: CAShapeLayer?
    private var arrowLayers: [CAShapeLayer]?
    
    /************** ORIENTATION *******************/
    private var currentOrientation: UIDeviceOrientation = .unknown
    private var previousOrientation: UIDeviceOrientation = .unknown
    
    /***************** CONCAT *********************/
    fileprivate var nextShowCase: BubbleShowCase?
    
    //MARK: Initializers
    
    /**
    Initializes a new Show Case View.
    
    - Parameter target:             The view that's targeted and whose feature is intended to be exaplained
    - Parameter arrowDirection:        The direction towards the show case must point the target
    - Parameter label:                *Optional*, an identifier for the show case
    
    */
    public init(target: UIView, arrowDirection: ArrowDirection, label: String? = nil) {
        self.target = target
        self.arrowDirection = arrowDirection
        self.label = label
        super.init(frame: CGRect.zero)
        
        setUp()
    }
    
    /**
    Initializes a new Show Case View.
    
    - Parameter target:             The bar button that's targeted and whose feature is intended to be exaplained
    - Parameter label:                *Optional*, an identifier for the show case
    
    - Remark:                        From iOS 11 onwards, the target must be a custom bar button item, that is, it must have been created by using *init(customView: UIView?)* constructor. If not so, it'll return *nil*
    - Note:                            The show case arrow direction will always point upwards
    
    */
    public init?(target: UIBarButtonItem, label: String? = nil) {
        let targetViewUnwrapped = target.customView ?? (target.value(forKey: "view") as? UIView)
        guard let targetView = targetViewUnwrapped else { return nil }
        
        self.target = targetView
        self.arrowDirection = .up
        self.label = label
        super.init(frame: CGRect.zero)
        
        isBarButton = true
        shouldWhitenScreenshot = true
        setUp()
    }
    
    
    /**
    Initializes a new Show Case View.
    
    - Parameter tabBar:             The tabBar where the show case should be installed over
    - Parameter index:                Index of the tab bar item which is the target
    - Parameter label:                *Optional*, an identifier for the show case
    
    - Remark:                        In case there's no room in screen, the UITabBarItem might be embeded in the "More" item. If so, the show case will place itself over this item.
    - Note:                            The show case arrow direction will always point downwards
    
    */
    public init(tabBar: UITabBar, index: Int, label: String? = nil) {
        let tabBarItems = tabBar.subviews.filter { $0.isKind(of: NSClassFromString("UITabBarButton")!) }
        
        let maxIndex = tabBarItems.count - 1
        let index = index < maxIndex ? index : maxIndex
        let target = tabBarItems[index]
        
        self.target = target
        self.arrowDirection = .down
        self.label = label
        super.init(frame: CGRect.zero)
        
        shouldWhitenScreenshot = true
        setUp()
    }
    
    /**
    Initializes a new Show Case View.
    
    - Parameter cell:                 The collection cell that's targeted
    - Parameter arrowDirection:        The direction towards the show case must point the target
    - Parameter target:                Target view whose feature is intended to be explained. If *nil*, the show case will target the whole cell.
    - Parameter label:                *Optional*, an identifier for the show case
    
    - Remark:                        If the cell isn't displayed, it'll scroll to make the cell visible.
    
    */
    public init(cell: UICollectionViewCell, target: UIView?, arrowDirection: ArrowDirection, label: String? = nil) {
        self.target = target ?? cell
        self.arrowDirection = arrowDirection
        self.label = label
        self.scrollView = cell.superview as? UIScrollView
        super.init(frame: CGRect.zero)
        
        setUp()
    }
    
    /**
    Initializes a new Show Case View. If the cell isn't displayed, it'll scroll to make the cell visible.
    
    - Parameter cell:                 The table cell that's targeted
    - Parameter arrowDirection:        The direction towards the show case must point the target
    - Parameter target:                Target view whose feature is intended to be explained. If *nil*, the show case will target the whole cell
    - Parameter label:                *Optional*, an identifier for the show case
    
    - Remark:                        If the cell isn't displayed, it'll scroll to make the cell visible.
    
    */
    public init(cell: UITableViewCell, target: UIView?, arrowDirection: ArrowDirection, label: String? = nil) {
        self.target = target ?? cell
        self.arrowDirection = arrowDirection
        self.label = label
        self.scrollView = cell.superview as? UIScrollView
        super.init(frame: CGRect.zero)
        
        setUp()
    }
    
    /// **Not implemented**. It raises a *Fatal Exepction*.
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not Implemented")
    }
    
    deinit {
        bubbleLeading = nil
        bubbleTrailing = nil
        screenshotTop = nil
        screenshotHeight = nil
        screenshotWidth = nil
        screenshotLeading = nil
        descriptionLeading = nil
        sideShowCaseCenterY = nil
        sideShowCaseTop = nil
        sideShowCaseBottom = nil
        nextShowCase = nil
    }
    
    //MARK: Public Methods
    
    /// Dismisses the show case out of the screen with an animation.
    public func dismiss() {
        animateDisappearance()
    }
    
    /**
    Displays the show case in the screen with an animation.
    
    - Remark: You should call this method after any change has happened in the screen.
    */
    public func show() {
        if !isInitialized {
            initialize()
        }
    }
    
    /// Call this method to concat a show case. It will be automatically displayed after this is completed.
    public func concat(bubbleShowCase: BubbleShowCase) {
        self.nextShowCase = bubbleShowCase
    }
    
    /// Displays the show case after the one passed as argument has finished.
    public func show(after bubbleShowCase: BubbleShowCase) {
        bubbleShowCase.nextShowCase = self
    }
    
    //MARK: Override
    
    public override func draw(_ rect: CGRect) {
        guard isInitialized else { return }
        
        if let _ = image, icon == nil {
            embedImage()
        }
        
        UIColor.black.withAlphaComponent(0.5).setFill()
        UIRectFill(rect)
        
        titleLabel.textColor = textColor
        descriptionLabel.textColor = textColor
        bubble.backgroundColor = color
        
        if let arrowLayers = arrowLayers {
            for arrowLayer in arrowLayers {
                fill(color: color, in: arrowLayer)
            }
        }
        
        if let crossLayer = crossLayer {
            let crossColor = self.crossColor ?? textColor
            fill(color: crossColor, in: crossLayer)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if arrowDirection == .left || arrowDirection == .right {
            updateSideConstraints()
        }
    }
    
    //MARK: Modification of constraints
    
    // Updates bubble top and bottom constraints to make fit the bubble into the screen. It should be called once the subviews have been rendered.
    private func updateSideConstraints() {
        guard let bubble = bubble else { return }
        let topAvailableSpace = screenshotContainer.frame.midY - margins
        let bottomAvailableSpace = screenWindow.frame.height - screenshotContainer.frame.midY - margins
        if topAvailableSpace < bubble.frame.height / 2 {
            sideShowCaseCenterY?.isActive = false
            sideShowCaseBottom?.isActive = false
            let topConstant = UIApplication.shared.statusBarFrame.size.height + margins
            if self.sideShowCaseTop == nil {
                let top = NSLayoutConstraint(item: bubble, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: topConstant)
                sideShowCaseTop = top
                addConstraint(top)
            } else {
                sideShowCaseTop?.isActive = true
                sideShowCaseTop?.constant = topConstant
            }
        } else if bottomAvailableSpace < bubble.frame.height / 2 {
            sideShowCaseCenterY?.isActive = false
            sideShowCaseTop?.isActive = false
            let bottomConstant = margins
            if self.sideShowCaseBottom == nil {
                let bottom = NSLayoutConstraint(item: bubble, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -bottomConstant)
                sideShowCaseBottom = bottom
                addConstraint(bottom)
            } else {
                sideShowCaseBottom?.isActive = true
                sideShowCaseBottom?.constant = -bottomConstant
            }
        } else {
            sideShowCaseCenterY?.isActive = true
            sideShowCaseTop?.isActive = false
            sideShowCaseBottom?.isActive = false
        }
        
        
        
        layoutIfNeeded()
    }
    
    //MARK: Initialization
    
    // Common set up for the showcase
    private func setUp() {
        currentOrientation = UIDevice.current.orientation
        previousOrientation = currentOrientation
        NotificationCenter.default.addObserver(self, selector: #selector(deviceDidRotate), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    // Initializes the show case hierarchy and displays the show case into the screen.
    private func initialize() {
        isInitialized = true
        self.isOpaque = false
        
        if shouldStopScrollView {
            scrollTargetToDisplay()
        }
        
        embedInSuperView()
        if arrowDirection != .leftAndRight && arrowDirection != .upAndDown && arrowDirection != .none {
            embedScreenshot()
        }
        
        embedBubble()
        
        embedLabels()
        
        if let _ = skipButtonText { embedSkipButton() }
        if isCrossDismissable { drawCross() }
        drawArrow()
        animateAppearance()
    }
    
    //MARK: Animations
    
    // Animates the appearance of both the show case and its subviews
    private func animateDisappearance() {
        delegate?.bubbleShowCaseWillDismiss?(self)
        nextShowCase?.show()
        UIView.animate(withDuration: dismissAnimationDuration, animations: { [weak self] in
            self?.alpha = 0
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.delegate?.bubbleShowCaseDidDismiss?(self)
                self.removeFromSuperview()
        })
    }
    
    // Animates the removal of the show case out of the screen
    private func animateAppearance() {
        delegate?.bubbleShowCaseWillTransitionIntoScreen?(self)
        alpha = 0
        bubble.alpha = 0
        screenshotContainer?.alpha = 0
        
        screenWindow.bringSubviewToFront(self)
        UIView.animate(withDuration: showAnimationDuration, animations: { [weak self] in
            self?.alpha = 1
            self?.screenshotContainer?.alpha = 1
            }, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.bubble.transform = CGAffineTransform(scaleX: 0.001, y: 0.001)
                self.bubble.alpha = 1
                
                UIView.animate(withDuration: self.showAnimationDuration, delay: self.showAnimationDuration, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: [], animations: { [weak self] in
                    self?.bubble.transform = .identity
                    }, completion: { [weak self] _ in
                        guard let `self` = self else { return }
                        self.delegate?.bubbleShowCaseDidTransitionIntoScreen?(self)
                        UIView.animate(withDuration: self.flickerAnimationDuration, delay: 0, options: [.autoreverse, .repeat, .allowUserInteraction], animations: { [weak self] in
                            self?.screenshotContainer?.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
                            }, completion: nil)
                })
        })
        
    }
    
    //MARK: Drawing
    
    // Redraws those elements that are affected by some change in the screen bounds
    private func redraw() {
        takeScreenshot()
        arrow.removeFromSuperview()
        drawArrow()
        
        bubble.isHidden = false
        screenshotContainer?.isHidden = false
        
        guard previousOrientation == .portrait || previousOrientation == .landscapeRight || previousOrientation == .landscapeLeft else { return }
        
        switch currentOrientation {
        case .portrait:
            bubbleLeading?.constant = (bubbleLeading?.constant ?? 0) - safeAreaMargins.top
            bubbleTrailing?.constant = (bubbleTrailing?.constant ?? 0) + safeAreaMargins.top
        case .landscapeLeft, .landscapeRight:
            bubbleLeading?.constant = (bubbleLeading?.constant ?? 0) + safeAreaMargins.left
            bubbleTrailing?.constant = (bubbleTrailing?.constant ?? 0) - safeAreaMargins.left
        case .portraitUpsideDown, .faceUp, .faceDown, .unknown:
            break
        @unknown default:
            break
        }
    }
    
    // Creates a button, draws a cross inside and places it at the top right of the bubble
    private func drawCross() {
        let cross = UIButton()
        self.cross = cross
        cross.addTarget(self, action: #selector(crossDidTap), for: .touchUpInside)
        cross.translatesAutoresizingMaskIntoConstraints = false
        bubble.addSubview(cross)
        
        let top = NSLayoutConstraint(item: cross, attribute: .top, relatedBy: .equal, toItem: bubble, attribute: .top, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: cross, attribute: .trailing, relatedBy: .equal, toItem: bubble, attribute: .trailing, multiplier: 1, constant: 0)
        let height = NSLayoutConstraint(item: cross, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: crossArea)
        let width = NSLayoutConstraint(item: cross, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: crossArea)
        addConstraints([top, trailing])
        cross.addConstraints([height, width])
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: crossPadding, y: crossPadding))
        path.addLine(to: CGPoint(x: crossPadding + crossSize, y: crossPadding + crossSize))
        
        path.move(to: CGPoint(x: crossPadding + crossSize, y: crossPadding))
        path.addLine(to: CGPoint(x: crossPadding, y: crossPadding + crossSize))
        path.close()
        
        let rect = CGRect(x: 0, y: 0, width: crossArea, height: crossArea)
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = rect
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = 2
        let crossColor = self.crossColor ?? textColor
        shapeLayer.strokeColor = crossColor.cgColor
        crossLayer = shapeLayer
        cross.layer.addSublayer(shapeLayer)
    }
    
    // Draws the arrow that the bubble will use to point to the target considering the direction specified.
    private func drawArrow() {
        guard arrowDirection != .none else { return }
        
        let arrow = UIView()
        self.arrow = arrow
        arrow.translatesAutoresizingMaskIntoConstraints = false
        bubble.addSubview(arrow)
        
        var arrow2: UIView! = nil
        var path2: UIBezierPath! = nil
        
        let path = UIBezierPath()
        let targetFrame = target.convert(target.bounds, to: screenWindow)
        
        switch arrowDirection {
        case .up:
            let top = NSLayoutConstraint(item: arrow, attribute: .top, relatedBy: .equal, toItem: bubble, attribute: .top, multiplier: 1, constant: -arrowSize)
            let leading = NSLayoutConstraint(item: arrow, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: targetFrame.midX - arrowSize)
            let height = NSLayoutConstraint(item: arrow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: arrowSize)
            let width = NSLayoutConstraint(item: arrow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 2 * arrowSize)
            
            bubble.addConstraint(top)
            addConstraint(leading)
            arrow.addConstraints([width, height])
            
            path.move(to: CGPoint(x: arrowSize, y: 0))
            path.addLine(to: CGPoint(x: 0, y: arrowSize))
            path.addLine(to: CGPoint(x: 2 * arrowSize, y: arrowSize))
            path.addLine(to: CGPoint(x: arrowSize, y: 0))
        case .down:
            let bottom = NSLayoutConstraint(item: arrow, attribute: .bottom, relatedBy: .equal, toItem: bubble, attribute: .bottom, multiplier: 1, constant: arrowSize)
            let leading = NSLayoutConstraint(item: arrow, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: targetFrame.midX - arrowSize)
            let height = NSLayoutConstraint(item: arrow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: arrowSize)
            let width = NSLayoutConstraint(item: arrow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 2 * arrowSize)
            
            bubble.addConstraint(bottom)
            addConstraint(leading)
            arrow.addConstraints([width, height])
            
            path.move(to: CGPoint(x: arrowSize, y: arrowSize))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 2 * arrowSize, y:  0))
            path.addLine(to: CGPoint(x: arrowSize, y: arrowSize))
        case .left:
            let top = NSLayoutConstraint(item: arrow, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: targetFrame.midY - arrowSize)
            let leading = NSLayoutConstraint(item: arrow, attribute: .leading, relatedBy: .equal, toItem: bubble, attribute: .leading, multiplier: 1, constant: -arrowSize)
            let height = NSLayoutConstraint(item: arrow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 2 * arrowSize)
            let width = NSLayoutConstraint(item: arrow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: arrowSize)
            
            bubble.addConstraint(leading)
            addConstraint(top)
            arrow.addConstraints([width, height])
            
            path.move(to: CGPoint(x: 0, y: arrowSize))
            path.addLine(to: CGPoint(x: arrowSize, y: 0))
            path.addLine(to: CGPoint(x: arrowSize, y:  2 * arrowSize))
            path.addLine(to: CGPoint(x: 0, y: arrowSize))
        case .right:
            let top = NSLayoutConstraint(item: arrow, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: targetFrame.midY - arrowSize)
            let trailing = NSLayoutConstraint(item: arrow, attribute: .trailing, relatedBy: .equal, toItem: bubble, attribute: .trailing, multiplier: 1, constant: arrowSize)
            let height = NSLayoutConstraint(item: arrow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 2 * arrowSize)
            let width = NSLayoutConstraint(item: arrow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: arrowSize)
            
            bubble.addConstraint(trailing)
            addConstraint(top)
            arrow.addConstraints([width, height])
            
            path.move(to: CGPoint(x: arrowSize, y: arrowSize))
            path.addLine(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: 0, y:  2 * arrowSize))
            path.addLine(to: CGPoint(x: arrowSize, y: arrowSize))
        case .upAndDown:
            let top = NSLayoutConstraint(item: arrow, attribute: .top, relatedBy: .equal, toItem: bubble, attribute: .top, multiplier: 1, constant: -arrowSize)
            let centerX = NSLayoutConstraint(item: arrow, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -arrowSize)
            let height = NSLayoutConstraint(item: arrow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: arrowSize)
            let width = NSLayoutConstraint(item: arrow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 2 * arrowSize)
            
            bubble.addConstraint(top)
            addConstraint(centerX)
            arrow.addConstraints([width, height])
            
            path.move(to: CGPoint(x: arrowSize, y: 0))
            path.addLine(to: CGPoint(x: 0, y: arrowSize))
            path.addLine(to: CGPoint(x: 2 * arrowSize, y: arrowSize))
            path.addLine(to: CGPoint(x: arrowSize, y: 0))
            
            path2 = UIBezierPath()
            arrow2 = UIView()
            arrow2.translatesAutoresizingMaskIntoConstraints = false
            bubble.addSubview(arrow2)
            
            let bottom2 = NSLayoutConstraint(item: arrow2!, attribute: .bottom, relatedBy: .equal, toItem: bubble, attribute: .bottom, multiplier: 1, constant: arrowSize)
            let centerX2 = NSLayoutConstraint(item: arrow2!, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: -arrowSize)
            let height2 = NSLayoutConstraint(item: arrow2!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: arrowSize)
            let width2 = NSLayoutConstraint(item: arrow2!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 2 * arrowSize)
            
            bubble.addConstraint(bottom2)
            addConstraint(centerX2)
            arrow2.addConstraints([width2, height2])
            
            path2.move(to: CGPoint(x: arrowSize, y: arrowSize))
            path2.addLine(to: CGPoint(x: 0, y: 0))
            path2.addLine(to: CGPoint(x: 2 * arrowSize, y:  0))
            path2.addLine(to: CGPoint(x: arrowSize, y: arrowSize))
        case .leftAndRight:
            let centerY = NSLayoutConstraint(item: arrow, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -arrowSize)
            let leading = NSLayoutConstraint(item: arrow, attribute: .leading, relatedBy: .equal, toItem: bubble, attribute: .leading, multiplier: 1, constant: -arrowSize)
            let height = NSLayoutConstraint(item: arrow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 2 * arrowSize)
            let width = NSLayoutConstraint(item: arrow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: arrowSize)
            
            bubble.addConstraint(leading)
            addConstraint(centerY)
            arrow.addConstraints([width, height])
            
            path.move(to: CGPoint(x: 0, y: arrowSize))
            path.addLine(to: CGPoint(x: arrowSize, y: 0))
            path.addLine(to: CGPoint(x: arrowSize, y:  2 * arrowSize))
            path.addLine(to: CGPoint(x: 0, y: arrowSize))
            
            path2 = UIBezierPath()
            arrow2 = UIView()
            arrow2.translatesAutoresizingMaskIntoConstraints = false
            bubble.addSubview(arrow2)
            
            let centerY2 = NSLayoutConstraint(item: arrow2!, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: -arrowSize)
            let trailing2 = NSLayoutConstraint(item: arrow2!, attribute: .trailing, relatedBy: .equal, toItem: bubble, attribute: .trailing, multiplier: 1, constant: arrowSize)
            let height2 = NSLayoutConstraint(item: arrow2!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 2 * arrowSize)
            let width2 = NSLayoutConstraint(item: arrow2!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: arrowSize)
            
            bubble.addConstraint(trailing2)
            addConstraint(centerY2)
            arrow2.addConstraints([width2, height2])
            
            path2.move(to: CGPoint(x: arrowSize, y: arrowSize))
            path2.addLine(to: CGPoint(x: 0, y: 0))
            path2.addLine(to: CGPoint(x: 0, y:  2 * arrowSize))
            path2.addLine(to: CGPoint(x: arrowSize, y: arrowSize))
        case .none:
            break
        }
        
        let layer = CAShapeLayer()
        layer.fillColor = color.cgColor
        layer.strokeColor = color.cgColor
        layer.lineWidth = 1
        layer.path = path.cgPath
        layer.frame = CGRect(origin: CGPoint.zero, size: arrow.frame.size)
        
        arrowLayers = [layer]
        if let path2 = path2 {
            let layer2 = CAShapeLayer()
            layer2.fillColor = color.cgColor
            layer2.strokeColor = color.cgColor
            layer2.lineWidth = 1
            layer2.path = path2.cgPath
            layer2.frame = CGRect(origin: CGPoint.zero, size: arrow2.frame.size)
            arrow2.layer.addSublayer(layer2)
            arrowLayers?.append(layer2)
        }
        
        arrow.layer.addSublayer(layer)
    }
    
    // MARK: Completion
    
    // Called whenever the cross is tapped
    @objc private func crossDidTap() {
        animateDisappearance()
    }
    
    //MARK: Utils
    
    // For UITableViewCell and UICollectionViewCell only. Returns if the target is within the screen bounds
    private var shouldStopScrollView: Bool {
        guard let scrollView = scrollView else { return false }
        
        let targetFrame = target.convert(target.bounds, to: scrollView)
        var height = scrollView.frame.size.height - targetFrame.height
        if #available(iOS 11, *) {
            height = height - scrollView.safeAreaInsets.bottom - scrollView.safeAreaInsets.top
        }
        
        let container = CGRect(x: scrollView.contentOffset.x,
                               y: scrollView.contentOffset.y,
                               width: scrollView.frame.size.width,
                               height: scrollView.frame.size.height - targetFrame.height);
        guard !targetFrame.intersects(container) else { return false }
        
        return true
    }
    
    // For UITableViewCell and UICollectionViewCell only. Makes the target visible in the screen.
    private func scrollTargetToDisplay() {
        guard let scrollView = self.scrollView else { return }
        
        scrollView.isScrollEnabled = false
        scrollView.isScrollEnabled = true
        var contentOffset = scrollView.contentOffset
        contentOffset.y = contentOffset.y + target.frame.height + 30
        scrollView.setContentOffset(contentOffset, animated: false)
    }
    
    // Changes the color of a layer.
    private func fill(color: UIColor, in layer: CAShapeLayer) {
        layer.fillColor = color.cgColor
        layer.strokeColor = color.cgColor
    }
    
    // Adds gestureRecognizers to the target screenshot to react to some gestures.
    private func addGestureRecognizersToScreenshot() {
        let longPressTapGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(targetDidLongPress))
        longPressTapGestureRecognizer.minimumPressDuration = 0.5
        screenshotContainer.addGestureRecognizer(longPressTapGestureRecognizer)
        
        let doubleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(targetDidDoubleTap(gestureRecognizer:)))
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.require(toFail: longPressTapGestureRecognizer)
        screenshotContainer.addGestureRecognizer(doubleTapGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(targetDidTap(gestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.require(toFail: doubleTapGestureRecognizer)
        screenshotContainer.addGestureRecognizer(tapGestureRecognizer)
        
        let swipeLeftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(targetDidSwipeLeft(gestureRecognizer:)))
        swipeLeftGestureRecognizer.direction = .left
        screenshotContainer.addGestureRecognizer(swipeLeftGestureRecognizer)
        
        let swipeRightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(targetDidSwipeRight(gestureRecognizer:)))
        swipeRightGestureRecognizer.direction = .right
        swipeRightGestureRecognizer.require(toFail: swipeLeftGestureRecognizer)
        screenshotContainer.addGestureRecognizer(swipeRightGestureRecognizer)
        
        let swipeUpGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(targetDidSwipeUp(gestureRecognizer:)))
        swipeUpGestureRecognizer.direction = .up
        swipeUpGestureRecognizer.require(toFail: swipeRightGestureRecognizer)
        screenshotContainer.addGestureRecognizer(swipeUpGestureRecognizer)
        
        let swipeDownGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(targetDidSwipeDown(gestureRecognizer:)))
        swipeDownGestureRecognizer.direction = .down
        swipeDownGestureRecognizer.require(toFail: swipeUpGestureRecognizer)
        screenshotContainer.addGestureRecognizer(swipeDownGestureRecognizer)
    }
    
    //MARK: Events
    
    // Device was rotated
    @objc private func deviceDidRotate() {
        guard isInitialized else { return }
        guard UIDevice.current.orientation != currentOrientation else { return }
        
        bubble.isHidden = true
        screenshotContainer?.isHidden = true
        
        previousOrientation = currentOrientation
        currentOrientation = UIDevice.current.orientation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(400)) { [weak self] in        // Gives time to the screen to update
            self?.redraw()
        }
    }
    
    // Screenshot was tapped
    @objc private func targetDidTap(gestureRecognizer: UIGestureRecognizer) {
        guard let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer else { return }
        delegate?.bubbleShowCase?(self, didTap: target, gestureRecognizer: tapGestureRecognizer)
    }
    
    // Screenshot was double long pressed
    @objc private func targetDidLongPress(gestureRecognizer: UIGestureRecognizer) {
        guard let longPressGestureRecognizer = gestureRecognizer as? UILongPressGestureRecognizer else { return }
        guard longPressGestureRecognizer.state == .ended else { return }
        delegate?.bubbleShowCase?(self, didLongPress: target, gestureRecognizer: longPressGestureRecognizer)
    }
    
    // Screenshot was double tapped
    @objc private func targetDidDoubleTap(gestureRecognizer: UIGestureRecognizer) {
        guard let tapGestureRecognizer = gestureRecognizer as? UITapGestureRecognizer else { return }
        delegate?.bubbleShowCase?(self, didDoubleTap: target, gestureRecognizer: tapGestureRecognizer)
    }
    
    // Screenshot was double swiped leftwards
    @objc private func targetDidSwipeLeft(gestureRecognizer: UIGestureRecognizer) {
        guard let swipeGestureRecognizer = gestureRecognizer as? UISwipeGestureRecognizer else { return }
        delegate?.bubbleShowCase?(self, didSwipeLeft: target, gestureRecognizer: swipeGestureRecognizer)
    }
    
    // Screenshot was double swiped rightwards
    @objc private func targetDidSwipeRight(gestureRecognizer: UIGestureRecognizer) {
        guard let swipeGestureRecognizer = gestureRecognizer as? UISwipeGestureRecognizer else { return }
        delegate?.bubbleShowCase?(self, didSwipeRight: target, gestureRecognizer: swipeGestureRecognizer)
    }
    
    // Screenshot was double swiped downwards
    @objc private func targetDidSwipeDown(gestureRecognizer: UIGestureRecognizer) {
        guard let swipeGestureRecognizer = gestureRecognizer as? UISwipeGestureRecognizer else { return }
        delegate?.bubbleShowCase?(self, didSwipeDown: target, gestureRecognizer: swipeGestureRecognizer)
    }
    
    // Screenshot was double swiped upwards
    @objc private func targetDidSwipeUp(gestureRecognizer: UIGestureRecognizer) {
        guard let swipeGestureRecognizer = gestureRecognizer as? UISwipeGestureRecognizer else { return }
        delegate?.bubbleShowCase?(self, didSwipeUp: target, gestureRecognizer: swipeGestureRecognizer)
    }
    
    //MARK: Embed subviews
    
    // Embeds the show case in the application window
    private func embedInSuperView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        screenWindow.addSubview(self)
        
        let top = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: screenWindow, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: screenWindow, attribute: .bottom, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: screenWindow, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: screenWindow, attribute: .trailing, multiplier: 1, constant: 0)
        
        screenWindow.addConstraints([top, bottom, leading, trailing])
    }
    
    // Embeds the screenshot in the show case
    private func embedScreenshot() {
        let screenshotContainer = UIView()
        self.screenshotContainer = screenshotContainer
        screenshotContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(screenshotContainer)
        addGestureRecognizersToScreenshot()
        
        if let shadowColor = self.shadowColor {
            screenshotContainer.layer.backgroundColor = UIColor.clear.cgColor
            screenshotContainer.layer.shadowColor = shadowColor.cgColor
            screenshotContainer.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
            screenshotContainer.layer.shadowOpacity = 0.5
            screenshotContainer.layer.shadowRadius = 5.0
        }
        
        screenshotTop = NSLayoutConstraint(item: screenshotContainer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
        screenshotLeading = NSLayoutConstraint(item: screenshotContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
        screenshotHeight = NSLayoutConstraint(item: screenshotContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 0)
        screenshotWidth = NSLayoutConstraint(item: screenshotContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 0)
        
        screenshotContainer.addConstraints([screenshotHeight, screenshotWidth])
        addConstraints([screenshotTop, screenshotLeading])
        
        takeScreenshot()
    }
    
    // Takes a screenshot and places it over the target
    private func takeScreenshot() {
        guard screenshotContainer != nil else { return }
        
        screenshotContainer.subviews.forEach { $0.removeFromSuperview() }
        
        let screenshotShadow = UIView()
        screenshotShadow.backgroundColor = .clear
        screenshotShadow.translatesAutoresizingMaskIntoConstraints = false
        screenshotContainer.addSubview(screenshotShadow)
        
        let top = NSLayoutConstraint(item: screenshotShadow, attribute: .top, relatedBy: .equal, toItem: screenshotContainer, attribute: .top, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint(item: screenshotShadow, attribute: .leading, relatedBy: .equal, toItem: screenshotContainer, attribute: .leading, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint(item: screenshotShadow, attribute: .trailing, relatedBy: .equal, toItem: screenshotContainer, attribute: .trailing, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: screenshotShadow, attribute: .bottom, relatedBy: .equal, toItem: screenshotContainer, attribute: .bottom, multiplier: 1, constant: 0)
        
        screenshotContainer.addConstraints([top, leading, trailing, bottom])
        
        screenshotShadow.layer.cornerRadius = 5
        screenshotShadow.layer.masksToBounds = true
        screenshotShadow.backgroundColor =  self.shouldWhitenScreenshot ? .white : .clear
        
        let barHeight: CGFloat = isBarButton ? 44 : 49
        let targetFrame = target.convert(target.bounds, to: screenWindow)
        var screenShotFrame = targetFrame
        if shouldWhitenScreenshot {
            screenShotFrame = CGRect(x: targetFrame.origin.x - 4,
                                     y: targetFrame.origin.y - (barHeight - targetFrame.height) / 2,
                                     width: targetFrame.width + 2 * 4,
                                     height: barHeight)
        }
        
        screenshotTop.constant = screenShotFrame.origin.y
        screenshotLeading.constant = screenShotFrame.origin.x
        screenshotHeight.constant = screenShotFrame.height
        screenshotWidth.constant = screenShotFrame.width
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(50)) { [weak self] in        // Takes the screenshot asynchronously while animating appearance
            guard let `self` = self else { return }
            
            let parent: UIView! = self.target.superview ?? self.target
            let screenshot: UIView! = parent.resizableSnapshotView(from: self.target.frame, afterScreenUpdates: false, withCapInsets: UIEdgeInsets.zero)
            screenshot.backgroundColor = self.sreenshotContainerBackground
            screenshot.translatesAutoresizingMaskIntoConstraints = false
            screenshot.isUserInteractionEnabled = false
            screenshotShadow.addSubview(screenshot)
            
            let centerXImage = screenshot.centerXAnchor.constraint(equalTo: screenshotShadow.centerXAnchor)
            let centerYImage = screenshot.centerYAnchor.constraint(equalTo: screenshotShadow.centerYAnchor)
            let widthImage = screenshot.widthAnchor.constraint(equalToConstant: targetFrame.width)
            let heightImage = screenshot.heightAnchor.constraint(equalToConstant: targetFrame.height)
            screenshotShadow.addConstraints([centerXImage, centerYImage, heightImage, widthImage])
        }
    }
    
    // Embeds the bubble in the show case view and places it next to the target according to the arrow direction
    private func embedBubble() {
        let bubble = UIView()
        self.bubble = bubble
        bubble.layer.cornerRadius = 5
        bubble.clipsToBounds = false
        bubble.translatesAutoresizingMaskIntoConstraints = false
        addSubview(bubble)
        
        let height = NSLayoutConstraint(item: bubble, attribute: .height, relatedBy: .greaterThanOrEqual, toItem: nil, attribute: .height, multiplier: 1, constant: 50)
        bubble.addConstraint(height)
        
        switch arrowDirection {
        case .up, .down:
            constraintBubbleForTopDirections()
        case .left, .right:
            contraintBubbleForSideDirections()
        case .leftAndRight, .upAndDown, .none:
            constraintBubbleForDoubleDirections()
        }
    }
    
    private func embedSkipButton() {
        let skipLabel = UILabel()
        self.skipLabel = skipLabel
        skipLabel.textColor = UIColor.white
        skipLabel.text = skipButtonText
        skipLabel.textAlignment = .center
        skipLabel.layer.backgroundColor  = color.cgColor
        skipLabel.layer.cornerRadius = 5
        skipLabel.isUserInteractionEnabled = true
        skipLabel.clipsToBounds = false
        skipLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(skipLabel)
        addGestureRecognizerToSkipButton()
        
        let height = NSLayoutConstraint(item: skipLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 45)
        let width = NSLayoutConstraint(item: skipLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 85)
        skipLabel.addConstraint(height)
        skipLabel.addConstraint(width)
        
        let centerX = NSLayoutConstraint(item: skipLabel, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -25)
        let bottom = NSLayoutConstraint(item: skipLabel, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: -25)
        
        addConstraint(centerX)
        addConstraint(bottom)
    }
    
    private func addGestureRecognizerToSkipButton() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(skipDidTap(gestureRecognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 1
        skipLabel.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc
    private func skipDidTap(gestureRecognizer: UITapGestureRecognizer) {
        delegate?.bubbleShowCaseWillSkipTutorial?()
    }
    
    // Constraints the bubble to the target for both leftAndSide and upAndDown arrow directions
    private func constraintBubbleForDoubleDirections() {
        guard let bubble = bubble else { return }
        let centerY = NSLayoutConstraint(item: bubble, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let centerX = NSLayoutConstraint(item: bubble, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        addConstraints([centerY, centerX])
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let maxSize: CGFloat = 420
            let width = NSLayoutConstraint(item: bubble, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: maxSize)
            addConstraint(width)
        } else {
            let leading = NSLayoutConstraint(item: bubble, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 2 * margins + safeAreaMargins.left)
            addConstraint(leading)
            bubbleLeading = leading
        }
    }
    
    // Constraints the bubble to the target for both left and right arrow directions
    private func contraintBubbleForSideDirections() {
        guard let bubble = bubble else { return }
        let centerY = NSLayoutConstraint(item: bubble, attribute: .centerY, relatedBy: .equal, toItem: screenshotContainer, attribute: .centerY, multiplier: 1, constant: 0)
        addConstraint(centerY)
        sideShowCaseCenterY = centerY
        
        if arrowDirection == .left {
            let leading = NSLayoutConstraint(item: bubble, attribute: .leading, relatedBy: .equal, toItem: screenshotContainer, attribute: .trailing, multiplier: 1, constant: margins + padding)
            addConstraint(leading)
        } else {
            let trailing = NSLayoutConstraint(item: bubble, attribute: .trailing, relatedBy: .equal, toItem: screenshotContainer, attribute: .leading, multiplier: 1, constant: -(margins + padding))
            addConstraint(trailing)
        }
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let maxSize: CGFloat = 420
            let width = NSLayoutConstraint(item: bubble, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: maxSize)
            addConstraint(width)
        } else {
            if arrowDirection == .left {
                let trailing = NSLayoutConstraint(item: bubble, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -margins - safeAreaMargins.right)
                bubbleTrailing = trailing
                addConstraint(trailing)
            } else {
                let leading = NSLayoutConstraint(item: bubble, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: margins + safeAreaMargins.left)
                bubbleLeading = leading
                addConstraint(leading)
            }
        }
    }
    
    // Constraints the bubble to the target for both up and down arrow directions
    private func constraintBubbleForTopDirections() {
        guard let bubble = bubble else { return }
        if arrowDirection == .up {
            let topConstant = margins + padding
            let top = NSLayoutConstraint(item: bubble, attribute: .top, relatedBy: .equal, toItem: screenshotContainer, attribute: .bottom, multiplier: 1, constant: topConstant)
            addConstraint(top)
        } else {
            let bottom = NSLayoutConstraint(item: bubble, attribute: .bottom, relatedBy: .equal, toItem: screenshotContainer, attribute: .top, multiplier: 1, constant: -margins - padding)
            addConstraint(bottom)
        }
        
        let leading: NSLayoutConstraint?
        let centerX: NSLayoutConstraint?
        
        let extraMargins: CGFloat = safeAreaMargins.left
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            let screenWidth = UIScreen.main.bounds.width
            let targetFrame = target.convert(target.bounds, to: UIApplication.shared.keyWindow!)
            let leftAvailableSpace = targetFrame.midX - extraMargins
            let rightAvailableSpace = screenWidth - targetFrame.midX - extraMargins
            let maxSize: CGFloat = 420
            
            if rightAvailableSpace > maxSize / 2, leftAvailableSpace > maxSize / 2 {
                leading = nil
                centerX = NSLayoutConstraint(item: bubble, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
            } else {
                centerX = nil
                if leftAvailableSpace > rightAvailableSpace {
                    leading = NSLayoutConstraint(item: bubble, attribute: .trailing, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .trailing, multiplier: 1, constant: -(margins + extraMargins))
                    bubbleTrailing = leading
                } else {
                    leading = NSLayoutConstraint(item: bubble, attribute: .leading, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .leading, multiplier: 1, constant: margins + extraMargins)
                    bubbleLeading = leading
                }
            }
            
            let width = NSLayoutConstraint(item: bubble, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 420)
            width.priority = .required
            addConstraint(width)
        } else {
            leading = NSLayoutConstraint(item: bubble, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: margins + extraMargins)
            bubbleLeading = leading
            centerX = NSLayoutConstraint(item: bubble, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        }
        
        if let leading = leading { addConstraint(leading) }
        if let centerX = centerX { addConstraint(centerX) }
    }
    
    // Embeds both the title and description into the show case
    private func embedLabels() {
        let titleLabel = UILabel()
        self.titleLabel = titleLabel
        titleLabel.numberOfLines = 0
        titleLabel.text = titleText
        titleLabel.font = titleFont
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubble.addSubview(titleLabel)
        
        let descriptionLabel = UILabel()
        self.descriptionLabel = descriptionLabel
        descriptionLabel.numberOfLines = 0
        descriptionLabel.text = descriptionText
        descriptionLabel.font = descriptionFont
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        bubble.addSubview(descriptionLabel)
        
        let descriptionLeading = NSLayoutConstraint(item: descriptionLabel, attribute: .leading, relatedBy: .equal, toItem: bubble, attribute: .leading, multiplier: 1, constant: bubblePadding.left)
        self.descriptionLeading = descriptionLeading
        let descriptionTrailing = NSLayoutConstraint(item: descriptionLabel, attribute: .trailing, relatedBy: .equal, toItem: bubble, attribute: .trailing, multiplier: 1, constant: -bubblePadding.right - crossArea)
        let descriptionBottom = NSLayoutConstraint(item: descriptionLabel, attribute: .bottom, relatedBy: .equal, toItem: bubble, attribute: .bottom, multiplier: 1, constant: -bubblePadding.bottom)
        bubble.addConstraints([descriptionLeading, descriptionTrailing, descriptionBottom])
        
        let titleLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: descriptionLabel, attribute: .leading, multiplier: 1, constant: 0)
        let titleTrailing = NSLayoutConstraint(item: titleLabel, attribute: .trailing, relatedBy: .equal, toItem: descriptionLabel, attribute: .trailing, multiplier: 1, constant: 0)
        let titleTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: bubble, attribute: .top, multiplier: 1, constant: bubblePadding.top)
        let titleBottom = NSLayoutConstraint(item: titleLabel, attribute: .bottom, relatedBy: .equal, toItem: descriptionLabel, attribute: .top, multiplier: 1, constant: -5)
        bubble.addConstraints([titleLeading, titleTrailing, titleTop, titleBottom])
    }
    
    // Embeds the icon in the show case, shifting the labels rightwards
    private func embedImage() {
        let icon = UIImageView(image: image)
        self.icon = icon
        icon.translatesAutoresizingMaskIntoConstraints = false
        bubble.addSubview(icon)
        
        let height = NSLayoutConstraint(item: icon, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: imageSize.height)
        let width = NSLayoutConstraint(item: icon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: imageSize.width)
        icon.addConstraints([height, width])
        
        let leading = NSLayoutConstraint(item: icon, attribute: .leading, relatedBy: .equal, toItem: bubble, attribute: .leading, multiplier: 1, constant: bubblePadding.left)
        let centerY = NSLayoutConstraint(item: icon, attribute: .centerY, relatedBy: .equal, toItem: bubble, attribute: .centerY, multiplier: 1, constant: 0)
        bubble.addConstraints([leading, centerY])
        
        bubble.removeConstraint(descriptionLeading)
        descriptionLeading = NSLayoutConstraint(item: descriptionLabel!, attribute: .leading, relatedBy: .equal, toItem: icon, attribute: .trailing, multiplier: 1, constant: 15)
        bubble.addConstraint(descriptionLeading)
    }
    
}
