//
//  BaseVCDelegate.swift
//  VideoBeautifier
//
//  Created by Hemrom, Sheetal Swati on 5/25/18.
//  Copyright © 2018 Hemrom, Sheetal Swati. All rights reserved.
//

import UIKit
import Foundation

@objc public protocol BaseVCDelegate:class {

    @available(iOS 6.0, *)
    @objc optional func baseNavigationBarColor() -> UIColor? // return the color you want
    
    @available(iOS 6.0, *)
    @objc optional func baseNavigationBarImage() -> UIImage? // return the image you want
    
    @available(iOS 6.0, *)
    @objc func shouldShowNavigationBar() -> Bool// return if you want NavigationBar
    
    @available(iOS 6.0, *)
    @objc optional func baseNavigationLeftButtonImage() -> UIImage?
    
    @available(iOS 6.0, *)
    @objc optional func baseNavigationRightButtonImage() -> UIImage?
    
    @available(iOS 6.0, *)
    @objc optional func baseNavigationPageTitle() -> String?
    
    @available(iOS 6.0, *)
    @objc optional func baseNavigationPageSubTitle() -> String?
    
    @available(iOS 6.0, *)
    @objc optional func baseNavigationBarHeight() -> CGFloat
    
    @available(iOS 6.0, *)
    @objc optional func didSelectLeftNavigationItem(navItem navigationItem:UIBarButtonItem)
    
    @available(iOS 6.0, *)
    @objc optional func didSelectRightNavigationItem(navItem navigationItem:UIBarButtonItem)
    
    
}
