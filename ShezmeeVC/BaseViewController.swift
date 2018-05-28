//
//  BaseViewController.swift
//  VideoBeautifier
//
//  Created by Hemrom, Sheetal Swati on 5/25/18.
//  Copyright © 2018 Hemrom, Sheetal Swati. All rights reserved.
//

import UIKit

open class BaseViewController: UIViewController,UINavigationBarDelegate {
    
    open weak var baseVCDelegate: BaseVCDelegate?
    
    static let NAVBAR_TAG:Int = 10
    static let LOADINGVIEW_TAG:Int = 22
    static let NAV_BAR_HEIGHT:CGFloat = 64
    var navItem:UINavigationItem?
    internal var destinationViewController: String=""
    
    
    //MARK: Overiden VC Methods
    open override func viewDidLoad() {
        super.viewDidLoad()
        updateNavigationBar(view.frame.size.width)
    }
    
    
    open override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        // Change width paramenter to previous height
        updateNavigationBar(view.frame.size.height)
    }
    

    open override var prefersStatusBarHidden: Bool{
        return true
    }
    

    // MARK: Navigation Bar UI methods
    private func updateNavigationBar(_ width:CGFloat) {
        
        if(!shouldAddNavBar()){
            return
        }
        
        var yTopPadding = UIApplication.shared.statusBarFrame.size.height;
        if(Utils.iSOSVersionLessThen11()){
            yTopPadding = 0;
        }
        while let navView = view.viewWithTag(BaseViewController.NAVBAR_TAG){
            navView.frame =  CGRect(x: 0, y: 0, width: width, height: navHeight())
            navView.updateConstraints()
            return
        }
        
        let navigationBar = UINavigationBar(frame: CGRect(x: 0, y: yTopPadding, width: width, height:navHeight()))
        navigationBar.delegate = self;
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white,NSAttributedStringKey.font: ThemeManager.sharedManager.getFontForSize(20)]
        navigationBar.tintColor = UIColor.clear
        
        // Set translucent
        navigationBar.shadowImage = UIImage()
        //navigationBar.translucent = true
        
        
        // Set background
        setNavigationBarBackground(navBarImage(navigationBar: navigationBar), navigationBar: navigationBar)
        //setBackground(UIImage(named: "nav_bar")!, navigationBar: navigationBar)
        
        
        // Create a navigation item with a title
        navItem = UINavigationItem()
        
        
        // Create two buttons for the navigation item
        if leftNavItem() != nil {
            setLeftNavigationItem(leftNavItem()!)
        }
        
        if rightNavItem() != nil {
            setRightNavigationItem(rightNavItem()!)
        }
        
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navItem!]
        navigationBar.tag = BaseViewController.NAVBAR_TAG
        
        
        // Make the navigation bar a subview of the current view controller
        view.addSubview(navigationBar)
        setNavigationTitleView(navItem: navItem!)
    }
    
    
    fileprivate func setNavigationTitleView( navItem : UINavigationItem)
    {
        //NSBundle* resourcesBundle = [NSBundle bundleForClass:[ClassA class]];
       // ClassA * class = [[ClassA alloc]initWithNibName:@"ClassA" bundle:resourcesBundle];
        
        let bundle = Bundle(identifier: "shezmee.ShezmeeVC")!
        guard let navTitleView = bundle.loadNibNamed("NavBarTitleView", owner: self, options: nil)?[0] as? NavBarTitleView else{ return }
        navTitleView.setTitleAndSubHeader(pageTitle().uppercased(), subheader: pageSubTitle())
        navItem.titleView = navTitleView
    }
    
    
    fileprivate func setNavigationBarBackground(_ image:UIImage , navigationBar :UINavigationBar)
    {
        navigationBar.setBackgroundImage(image, for: .default)
    }
    
    
    fileprivate func addNavigationButton(withImage image:UIImage  , title:String ,action:Selector) -> UIBarButtonItem{
        let leftButton = UIBarButtonItem()
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 51, height: 31))
        button.imageView?.contentMode = .scaleAspectFit
        button.setImage(image, for: UIControlState())
        button.setTitle(title, for: UIControlState())
        button.addTarget(self, action: action, for: .touchUpInside)
        leftButton.customView = button
        return leftButton
    }
    
    
    func setRightNavigationItem(_ image:UIImage)
    {
        navItem!.rightBarButtonItem = addNavigationButton(withImage: image, title: "", action: #selector(rightNavItemClicked(_:)))
    }
    
    func setLeftNavigationItem(_ image:UIImage)
    {
        navItem!.leftBarButtonItem = addNavigationButton(withImage: image, title: "", action: #selector(leftNavItemClicked(_:)))
    }
    
    
    
    func isModal() ->Bool {
        guard self.presentingViewController == nil else {return true}
        guard self.presentingViewController?.presentedViewController != self else {return true}
        guard self.navigationController?.presentingViewController?.presentedViewController != self.navigationController else {return true}
        guard !(self.tabBarController?.presentingViewController is UITabBarController) else {return true}
        return false;
    }
    
    
    //MARK: BaseVCDelegate methods
    func shouldAddNavBar() -> Bool{
        guard let delegate = baseVCDelegate else{
            return false
        }
        return delegate.shouldShowNavigationBar()
    }
    
    func navBarImage( navigationBar : UINavigationBar) -> UIImage{
        guard let delegate = baseVCDelegate else{
            return UIImage()
        }
        guard let color = delegate.baseNavigationBarColor!() else {
            // optional not implemented
            guard let image = delegate.baseNavigationBarImage!() else {
                return UIImage()
            }
            return image
        }
        return Utils.getImageWithColor(color, size: navigationBar.frame.size)
    }
    
    func rightNavItem() -> UIImage?{
        guard let delegate = baseVCDelegate else{
            return nil
        }
        guard let image = delegate.baseNavigationRightButtonImage?() else {
            return nil
        }
        return image
    }
    
    func leftNavItem() -> UIImage?{
        guard let delegate = baseVCDelegate else{
            return nil
        }
        guard let image = delegate.baseNavigationLeftButtonImage?() else {
            return nil
        }
        return image
    }
    
    func pageTitle() -> String{
        guard let delegate = baseVCDelegate else{
            return ""
        }
        guard let title = delegate.baseNavigationPageTitle?() else {
            return ""
        }
        return title
    }
    
    func pageSubTitle() -> String{
        guard let delegate = baseVCDelegate else{
            return ""
        }
        guard let title = delegate.baseNavigationPageSubTitle?() else {
            return ""
        }
        return title
    }
    
    func navHeight() -> CGFloat{
        guard let delegate = baseVCDelegate else{
            return BaseViewController.NAV_BAR_HEIGHT
        }
        guard let barHeight = delegate.baseNavigationBarHeight?() else {
            return BaseViewController.NAV_BAR_HEIGHT
        }
        return barHeight
    }
    
    @objc func rightNavItemClicked(_ sender:UIBarButtonItem) {
        guard let delegate = baseVCDelegate else{
            return
        }
        delegate.didSelectRightNavigationItem?(navItem: sender)
    }
    
    @objc func leftNavItemClicked(_ sender: UIBarButtonItem) {
        guard let delegate = baseVCDelegate else{
            return
        }
        delegate.didSelectLeftNavigationItem?(navItem: sender)
    }
    
    //MARK: ShowHideLoader methods
    func showLoadingView(_ type : LOADING_VIEW_TYPE ){
        Utils.showLoadingView(type,inView: view, loaderColor: UIColor.green)
    }
    
    
    func hideLoadingView(){
        Utils.hideLoadingView(view)
    }

    
    
}
