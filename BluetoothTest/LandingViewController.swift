//
//  LandingViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/8/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    let loginButton = UIButton(type: UIButtonType.System) as UIButton
    let signupButton = UIButton(type: UIButtonType.System) as UIButton
    let backgroundImageView = UIImageView()
    let logoView = UIImageView()
    let titleView = UILabel()
    
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
        
        view.addSubview(backgroundImageView)
//        view.addSubview(blurEffectView)
        
        view.addSubview(loginButton)
        view.addSubview(signupButton)
        view.addSubview(logoView)
        view.addSubview(titleView)
        
        // Set the background image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.image = UIImage(named: "background2.png")!
        backgroundImageView.alpha = 0.5
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp_center)
            make.size.equalTo(view.snp_size)
        }

        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = "Cohesve"
        titleView.textColor = UIColor.whiteColor()
        titleView.font = UIFont(name: titleView.font.fontName, size: 72)
        titleView.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_centerY)
        }
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.frame = CGRectMake(logoView.frame.origin.x, logoView.frame.origin.y, 100, 50)
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        logoView.image = UIImage(named: "logo.png")!
        logoView.snp_makeConstraints { (make) -> Void in
            //make.height.equalTo(UIConstants.logoHeightLarge)
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(titleView.snp_top)
            make.height.equalTo(UIConstants.logoHeightLarge)
        }
        
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.setTitle("Join", forState: .Normal)
        signupButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupButton.backgroundColor = UIConstants.primaryColor
        signupButton.layer.cornerRadius = 5
        signupButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.centerY.equalTo(view.snp_centerY).offset(50)
            make.width.equalTo(200)
        }
        signupButton.addTarget(self, action: "handleSignup:", forControlEvents: UIControlEvents.TouchUpInside)
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.setTitle("Sign In", forState: .Normal)
        loginButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        loginButton.layer.borderColor = UIColor.whiteColor().CGColor
        loginButton.layer.cornerRadius = 5
        loginButton.layer.borderWidth = 0.5
        loginButton.backgroundColor = UIColor(white: 1, alpha: 0.1)
        loginButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(signupButton.snp_bottom).offset(16)
            make.width.equalTo(200)
        }
        loginButton.addTarget(self, action: "handleLogin:", forControlEvents: UIControlEvents.TouchUpInside)

//        UIGraphicsBeginImageContext(self.view.frame.size)
//        background.drawInRect(CGRect(x: self.view.frame.width/2 - background.size.width/2, y: 0, width: background.size.width, height: self.view.frame.height))
//        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createView()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
