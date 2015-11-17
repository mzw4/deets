//
//  LandingViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/8/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import LTMorphingLabel


extension UILabel {
    func kern(kerningValue:CGFloat) {
        self.attributedText =  NSAttributedString(string: self.text ?? "", attributes: [NSKernAttributeName:kerningValue, NSFontAttributeName:font, NSForegroundColorAttributeName:self.textColor])
    }
}

class LandingViewController: UIViewController {
    
    let loginButton = UIButton(type: UIButtonType.System) as UIButton
    let signupButton = UIButton(type: UIButtonType.System) as UIButton
    let backgroundImageView = UIImageView()
    let logoView = UIImageView()
    let titleView = UILabel()
    let tagline = UILabel()
    var startKern:CGFloat = -50.0
    
    func handleSignup(sender: UIButton!) {
        let signupVC = SignupViewController()
        self.presentViewController(signupVC, animated: true, completion: nil)
    }
    
    func handleLogin(sender: UIButton!) {
        let loginVC = LoginViewController()
        self.presentViewController(loginVC, animated: true, completion: nil)
        
    }
    
    func createView() {
        view.backgroundColor = UIColor.blackColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        LoginViewController().view.alpha = 0.0

        view.addSubview(backgroundImageView)
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(logoView)
        view.addSubview(titleView)
        view.addSubview(tagline)
//        view.addSubview(LoginViewController().view)
        
        view.layoutIfNeeded()
        
        // Set the background image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.image = UIImage(named: "background2.png")!
        backgroundImageView.alpha = 0.23
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp_center)
            make.size.equalTo(view.snp_size)
        }

        // Logo and title
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = "COHESVE"
        titleView.sizeToFit()
        titleView.textColor = UIColor.whiteColor()
//        titleView.font = UIFont.systemFontOfSize(40, weight: UIFontWeightSemibold) 
        titleView.font = UIFont(name: "FranklinGothic-Demi", size: 47)
        titleView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_centerY).offset(-35)
            make.height.lessThanOrEqualTo(200)
        }
        titleView.kern(-500.0)
        titleView.textAlignment = NSTextAlignment.Center
        titleView.alpha = 0.0

        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.frame = CGRectMake(logoView.frame.origin.x, logoView.frame.origin.y, 100, 50)
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        logoView.image = UIImage(named: "logo.png")!
        logoView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(titleView.snp_top).offset(35)
            make.width.equalTo(view.snp_width).multipliedBy(0.3)
        }
        logoView.hidden = true
        
        // Tagline
        tagline.translatesAutoresizingMaskIntoConstraints = false
        tagline.text = StringConstants.tagline
        tagline.sizeToFit()
        tagline.textColor = UIColor.whiteColor()
        tagline.font = UIFont.systemFontOfSize(20, weight: UIFontWeightThin)
        tagline.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(titleView.snp_bottom).offset(10)
        }
        tagline.layoutIfNeeded()
        tagline.kern(1.0)
        tagline.alpha = 0.0
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.setTitle("Join", forState: .Normal)
        signupButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.backgroundColor = UIConstants.primaryColor        
        signupButton.layer.cornerRadius = 5
        signupButton.titleLabel!.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        signupButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(loginButton.snp_top).offset(-UIConstants.spacing1-1)
            make.width.equalTo(view.snp_width).multipliedBy(0.7)
            make.height.equalTo(47)
        }
        signupButton.addTarget(self, action: "handleSignup:", forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.alpha = 0
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Sign In", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 0.6
        loginButton.titleLabel!.font = UIFont.systemFontOfSize(18, weight: UIFontWeightMedium)
        loginButton.backgroundColor = UIColor(white: 1, alpha: 0.1)
        loginButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(view.snp_centerY).offset(140)
            make.width.equalTo(view.snp_width).multipliedBy(0.7)
            make.height.equalTo(47)
        }
        loginButton.addTarget(self, action: "handleLogin:", forControlEvents: UIControlEvents.TouchUpInside)
        loginButton.alpha = 0

//        UIGraphicsBeginImageContext(self.view.frame.size)
//        background.drawInRect(CGRect(x: self.view.frame.width/2 - background.size.width/2, y: 0, width: background.size.width, height: self.view.frame.height))
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.view.backgroundColor = UIColor(patternImage: image)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        createView()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        NSTimer.scheduledTimerWithTimeInterval(0.011, target: self, selector: "kern", userInfo: nil, repeats: true)

        UIView.animateWithDuration(2.0, delay: 0.5, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
            
//            self.titleView.kern(5.0)
            self.titleView.alpha = 1
            self.tagline.alpha = 1
            self.view.layoutIfNeeded()
            
            }, completion: nil)
        
        UIView.animateWithDuration(2.0, delay: 0.8, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: { () -> Void in
            
            self.signupButton.alpha = 1
            self.loginButton.alpha = 1
            
            }, completion: nil)
    }
    
    func kern(){
        if startKern < -5.0{
            startKern = startKern + 1
            titleView.kern(startKern)
        }else if startKern < 5.0{
            startKern = startKern + 0.5
            titleView.kern(startKern)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */

}
