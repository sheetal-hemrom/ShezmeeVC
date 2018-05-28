//
//  NavBarTitleView.swift
//  VideoBeautifier
//
//  Created by Hemrom, Sheetal Swati on 5/25/18.
//  Copyright © 2018 Hemrom, Sheetal Swati. All rights reserved.
//

import UIKit
@IBDesignable
class NavBarTitleView: UIView {
    
    
    @IBOutlet weak var header:UILabel?
    @IBOutlet weak var subHeader:UILabel?
    @IBOutlet weak var headerYAxis:NSLayoutConstraint?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        header?.textColor = UIColor.white
        subHeader?.textColor = UIColor.white
        isUserInteractionEnabled = true
    }
    
    @IBInspectable
    public var cornerRadius: CGFloat = 2.0 {
        didSet {
            self.layer.cornerRadius = self.cornerRadius
        }
    }
    
    
    func setTitleAndSubHeader(_ title:String , subheader:String)
    {
        header?.text = title
        subHeader?.text = subheader
        if subheader.isEmpty {
            header?.font = ThemeManager.sharedManager.getFontForSize(25.0)
            headerYAxis?.constant = 0
        }
        else{
            header?.font = ThemeManager.sharedManager.getFontForSize(22.0)
            headerYAxis?.constant = -10
        }
    }
    
    func getDisplayName() -> String{
        if(!(header!.text!.isEmpty) && !(subHeader!.text!.isEmpty))
        {
            return "\(header!.text!):\(subHeader!.text!)"
        }else if(!(header!.text!.isEmpty)){
            return "\(header!.text!)"
        }
        return "";
    }
    
    override var intrinsicContentSize: CGSize {
        // IOS 11 navigation bar issue fix
        let size = self.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    
}
