//
//  Utils.swift
//  Shezmee
//
//  Created by Sheetal Swati Hemron on 8/22/16.
//  Copyright © 2016 Manulife. All rights reserved.
//

import UIKit
import Foundation
import MessageUI

public enum LOADING_VIEW_TYPE{
    case blocking,non_BLOCKING,white_BLOCKING,blocking_CLEAR,non_BLOCKING_CLEAR
}
class Utils: NSObject {
    
    class func showAlert(_ title :String ,message :String?) ->Void{
        
        var msg = ""
        if  message != nil && !((message?.isEmpty)!){
            msg = message!
        }
        if msg.lowercased().contains("token"){
            // Change the display message to a more readable one
            msg = "Your session has expired. Please login again"
        }
        let alertVC = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (UIAlertAction) in}
        alertVC.addAction(okAction)
        let vc = Utils.getTopViewController()
        
        if(vc is UIAlertController){
            let alertVC:UIAlertController = vc as! UIAlertController
            if(alertVC.message == msg){
                // If there is already alert showing same message/title. We don't need multiple alerts
                return
            }
        }
        DispatchQueue.main.async { () -> Void in
            vc.present(alertVC, animated: true, completion: nil)
        }
    }
    
    class func getAppVersion() -> NSString
    {
        let version =  Bundle.main.infoDictionary!["CFBundleShortVersionString"]!
        let buildNo = Bundle.main.infoDictionary!["CFBundleVersion"]!
        return "\(version) (\(buildNo))" as NSString
    }
    
    class func dateWithString(_ dateFormat:String , stringDate:String)-> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone(identifier: "GMT")
        if let date:Date = dateFormatter.date(from: stringDate) {
            return date
        }else{
            //Try another format and if this doesn't work as well kill the service guy
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return dateFormatter.date(from: stringDate)!
        }
        
    }
    
    class  func roundButtonCorners(_ view :UIView)
    {
        view.layer.cornerRadius = view.frame.width/2
        view.layer.masksToBounds = true
    }
    
    
    class func getImageWithColor(_ color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    class func getImageWithGradientColor(_ size: CGSize , topcolor:UIColor , bottomColor:UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let gradientLocations:[CGFloat] = [0.0, 1.0]
        let gradientComponets = [topcolor, bottomColor]
        let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientComponets as CFArray, locations: gradientLocations)
        UIGraphicsGetCurrentContext()?.drawLinearGradient(gradient!, start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: size.height), options: CGGradientDrawingOptions.drawsBeforeStartLocation);
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
 
    
    
    class func imageWithTitle(_ image:UIImage , title : NSString , color : UIColor) -> UIImage
    {
        let font = ThemeManager.sharedManager.getFontForSize(16.0)
        let expectedTextSize:CGSize = title.size(withAttributes: [NSAttributedStringKey.font: font])
        let width = expectedTextSize.width + image.size.width + 5
        let height = max(expectedTextSize.height, image.size.width)
        let size = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0);
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        let fontTopPosition = (height - expectedTextSize.height)/2
        let textPoint:CGPoint = CGPoint(x: image.size.width + 5 , y: fontTopPosition)
        
        title.draw(at: textPoint, withAttributes:[NSAttributedStringKey.font: font])
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height);
        context.concatenate(flipVertical);
        context.draw(image.cgImage!, in: CGRect(x: 0, y: (height - image.size.height) / 2, width: image.size.width, height: image.size.height));
        let newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage!
        
    }
    
    
    
    class func removeObjectFromArray<T : Equatable>(_ object: T, fromArray array: inout [T])
    {
        let index = array.index(of: object)
        array.remove(at: index!)
    }
    
    
    
    class func displayToastMessage(_ message:String , sender:UIView , viewWhereToastWillBeAdded:UIView)
    {
        let size:CGSize = message.size(withAttributes: [NSAttributedStringKey.font:ThemeManager.sharedManager.getFontForSize(20)])
        let label = UILabel(frame: CGRect(x: sender.frame.origin.x, y: sender.frame.origin.y-60 ,width: size.width + 20, height: size.height + 20) )
        label.backgroundColor = UIColor.black
        label.textAlignment = .center
        label.font = ThemeManager.sharedManager.getFontForSize(20)
        label.textColor = UIColor.white
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.text = message
        viewWhereToastWillBeAdded.addSubview(label)
        
        let duration:Int64 = 2;
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(duration *  Int64( NSEC_PER_SEC)) / Double(NSEC_PER_SEC)) {
            label.removeFromSuperview()
        }
    }
    
    class func getViewControllerWithIndentifier(_ identifier:String) ->BaseViewController
    {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        let viewController:BaseViewController = mainStoryboard.instantiateViewController(withIdentifier: identifier) as! BaseViewController
        viewController.destinationViewController = identifier
        return viewController
    }
    
    
    class func takeScrenshot() -> UIImage
    {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil)
        return screenshot!
    }
    
    
    
    class func getTopViewController() -> UIViewController
    {
        if (UIApplication.shared.keyWindow?.rootViewController) is UISplitViewController
        {
            let splitViewController:UISplitViewController = (UIApplication.shared.keyWindow?.rootViewController)! as! UISplitViewController
            let navController = splitViewController.childViewControllers[1] as! UINavigationController
            let topViewController = navController.viewControllers.last
            if(topViewController?.presentedViewController != nil){
                if (topViewController?.presentedViewController is UINavigationController){
                    let vc = topViewController?.presentedViewController?.childViewControllers.last
                    return vc!
                }
                return topViewController!.presentedViewController!
            }
            return topViewController!
        }else{
            return (UIApplication.shared.keyWindow?.rootViewController)!
        }
    }
    
    class func getKeyboardHeight(_ notification:Notification)->CGFloat{
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        return keyboardRectangle.height
    }
    
    
    class func sendEmail(_ image:UIImage? , mailDelegate:MFMailComposeViewControllerDelegate, title:String , messageBody:String,mailRecipients:[String])
    {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = mailDelegate
            mail.setToRecipients(mailRecipients)
            mail.setSubject(title)
            mail.setMessageBody(messageBody, isHTML: true)
            if image != nil {
                mail.addAttachmentData(UIImagePNGRepresentation(image!)!, mimeType: "image/png", fileName: "Screenshot")
            }
            (mailDelegate as! UIViewController).present(mail, animated: true, completion: nil)
        } else {
            showAlert("Error", message: "Sorry, This facility is not available on your device")
        }
    }
    
    class func showLoadingView(_ type : LOADING_VIEW_TYPE , inView:UIView , loaderColor:UIColor){
        
        guard inView.viewWithTag(BaseViewController.LOADINGVIEW_TAG) == nil else {return}
        
        var viewframe = inView.frame
        viewframe.origin.y = BaseViewController.NAV_BAR_HEIGHT
        let loadingView = UIView(frame: viewframe)
        switch type {
        case .blocking:
            inView.isUserInteractionEnabled = false
            loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            break
        case .white_BLOCKING:
            inView.isUserInteractionEnabled = false
            loadingView.backgroundColor = UIColor.white.withAlphaComponent(1)
            break
        case .blocking_CLEAR:
            inView.isUserInteractionEnabled = false
            loadingView.backgroundColor = UIColor.clear
            break
        case .non_BLOCKING_CLEAR:
            loadingView.backgroundColor = UIColor.clear
            break
        default:
            inView.isUserInteractionEnabled = true
            loadingView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
            break
        }
        // Add background view
        loadingView.tag = BaseViewController.LOADINGVIEW_TAG
        inView.addSubview(loadingView)
        
        // Add indicator
        let indicatorframe =  CGRect(x: inView.frame.size.width/2 - 25, y: inView.frame.size.height/2 - 25, width: 50, height: 50)
        let indicator:UIActivityIndicatorView = UIActivityIndicatorView(frame: indicatorframe)
        indicator.activityIndicatorViewStyle = .whiteLarge
        indicator.color = loaderColor
        indicator.startAnimating()
        inView.bringSubview(toFront: loadingView)
        loadingView.addSubview(indicator)
        
        // Add constraints for indicator
        let xConstraint = NSLayoutConstraint(item: indicator, attribute: .centerX, relatedBy: .equal, toItem: loadingView, attribute: .centerX, multiplier: 1, constant:0)
        let yConstraint = NSLayoutConstraint(item: indicator, attribute: .centerY, relatedBy: .equal, toItem: loadingView, attribute: .centerY, multiplier: 1, constant: 0)
        loadingView.addConstraints([xConstraint,yConstraint])
    }
    
    class func hideLoadingView(_ inView:UIView)
    {
        inView.isUserInteractionEnabled = true
        if let loadingView = inView.viewWithTag(BaseViewController.LOADINGVIEW_TAG) {
            loadingView.removeFromSuperview()
        }
    }
    
    class func isIpad() -> Bool{
        if (UI_USER_INTERFACE_IDIOM() == .pad){return true}
        return false
    }
    
    class func getDeviceModel() -> String{
        if let simulatorModelIdentifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"] { return simulatorModelIdentifier }
        var sysinfo = utsname()
        uname(&sysinfo) // ignore return value
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
    }
    

    
    class func iSOSVersionLessThen11() -> Bool{
        let osVersion = UIDevice.current.systemVersion
        guard Float(osVersion)! < 11.0 else {return false}
        return true
    }
    
    class func customizeStatusBar(color : UIColor){
        //Status bar issue fix for iOS 11
        if(!Utils.iSOSVersionLessThen11()){
            let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
            if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = color
            }
        }
    }
}

