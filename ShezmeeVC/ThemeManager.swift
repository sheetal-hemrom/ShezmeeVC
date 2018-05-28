//
//  ThemeManager.swift
//  VideoBeautifier
//
//  Created by Hemrom, Sheetal Swati on 5/25/18.
//  Copyright © 2018 Hemrom, Sheetal Swati. All rights reserved.
//

import UIKit
import Foundation

open class ThemeManager : NSObject {
    
    open static let sharedManager: ThemeManager = {
        let instance = ThemeManager()
        return instance
    }()
    
    func getFontForSize(_ fontSize:CGFloat) -> UIFont
    {
        return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
    }
    
    func getBoldFontForSize(_ fontSize:CGFloat) -> UIFont
    {
        return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)
    }
    
    
    func getBRCLimitColor() ->UIColor{
        return UIColor.init(red: 240/255, green: 37/255, blue: 50/255, alpha: 1)
    }
    
    func getManagementLimitColor() ->UIColor{
        return UIColor.init(red: 100/255, green: 155/255, blue: 255/255, alpha: 1)
    }
    
    func getLighterManulifeGray() -> UIColor
    {
        return UIColor.gray
    }
    
    func getColorWithPatternImage(_ imageName : String) -> UIColor
    {
        return UIColor(patternImage: UIImage(named: imageName)!)
    }
    
    func getImageFromColor(_ color:UIColor) -> UIImage
    {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
        //let colorImage = UIColor.imageFromColor(color,frame: frame)
        //return colorImage
    }
    
    
    func addGradientToView(_ view:UIView , colors:[UIColor])
    {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = colors
        gradient.locations = [0.0,1.0]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func showShadowForView(_ view:UIView , shadowOpacity :Float )
    {
        view.layer.masksToBounds = false;
        view.layer.shadowOffset = CGSize(width: -15, height: 20);
        view.layer.shadowRadius = 5;
        view.layer.shadowOpacity = shadowOpacity;
    }
    
    
}

