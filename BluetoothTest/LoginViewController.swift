//
//  LoginViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/7/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import Firebase
import SnapKit

class LoginViewController: UIViewController {
    
    let firebaseRef = Firebase(url:"https://fiery-heat-4470.firebaseio.com")
    
    let logoView = UIImageView()
    let titleView = UILabel()
    let tagline = UILabel()
    let backgroundImageView = UIImageView()
    
    let emailField = UITextField()
    let passwordField = UITextField()
    let signinbutton = UIButton(type: UIButtonType.System) as UIButton
    let forgotPassButton = UIButton(type: UIButtonType.System) as UIButton
    let errorText = UILabel()
    
    func loginUser(sender: UIButton!) {
        if (validateFields()) {
            //        firebaseRef.authUser("bobtony@example.com", password: "correcthorsebatterystaple",
            firebaseRef.authUser(emailField.text, password: passwordField.text,
                withCompletionBlock: { error, authData in
                    if error != nil {
                        // There was an error logging in to this account
                        print("Error logging in! \(error)")
                        self.errorText.text = "Invalid email or password. Try again!"
                    } else {
                        // We are now logged in
                        let email = authData.providerData["email"]
                        print("\(authData) logged in with email \(email) and id \(authData.uid)")
                        
                        self.errorText.text = ""
                        let VC = ViewController()
                        self.presentViewController(VC, animated: true, completion: nil)
                    }
            })
        }
    }
    
    func validateFields() -> Bool {
        return true
    }
    
    func createView() {
        view.backgroundColor = UIColor.blackColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        view.addSubview(backgroundImageView)
        view.addSubview(blurEffectView)
        view.addSubview(logoView)
        view.addSubview(titleView)
        view.addSubview(tagline)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signinbutton)
        view.addSubview(forgotPassButton)
        view.addSubview(errorText)
        
        // Set the background image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.image = UIImage(named: "background2.png")!
        backgroundImageView.alpha = 0.5
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp_center)
            make.size.equalTo(view.snp_size)
        }
        
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.frame = CGRectMake(logoView.frame.origin.x, logoView.frame.origin.y, 100, 50)
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        logoView.image = UIImage(named: "logo.png")
        logoView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(view.snp_left).offset(UIConstants.leftMargin)
            make.top.equalTo(view.snp_top).offset(UIConstants.topMargin)
            make.height.equalTo(UIConstants.logoHeightLarge)
            make.width.equalTo(UIConstants.logoWidthLarge)
        }
        
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = "Cohesve"
        titleView.textColor = UIColor.whiteColor()
        titleView.font = UIFont(name: titleView.font.fontName, size: CGFloat(UIConstants.fontMed))
        titleView.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(logoView.snp_centerY)
            make.left.equalTo(logoView.snp_right).offset(UIConstants.spacing1)
        }
    
        // Email field
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.textColor = UIColor.whiteColor()
        emailField.tintColor = UIColor.whiteColor()
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIConstants.fadedColor])
        emailField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(logoView.snp_bottom).offset(UIConstants.spacing2)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(UIConstants.fieldWidth)
        }
        
        // Password field
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.textColor = UIColor.whiteColor()
        passwordField.tintColor = UIColor.whiteColor()
        passwordField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSForegroundColorAttributeName:UIConstants.fadedColor])
        passwordField.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(emailField.snp_bottom).offset(UIConstants.spacing1)
            make.width.equalTo(UIConstants.fieldWidth)
        }
        passwordField.secureTextEntry = true
        
        // Signin button
        signinbutton.translatesAutoresizingMaskIntoConstraints = false
        signinbutton.setTitle("Login", forState: .Normal)
        signinbutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signinbutton.backgroundColor = UIConstants.primaryColor
        signinbutton.layer.cornerRadius = 5
        signinbutton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(passwordField.snp_bottom).offset(16)
            make.width.equalTo(200)
        }
        signinbutton.addTarget(self, action: "loginUser:", forControlEvents: UIControlEvents.TouchUpInside)
        
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.textColor = UIColor.redColor()
        errorText.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(signinbutton.snp_bottom).offset(16)
            make.height.equalTo(12)
            make.width.equalTo(200)
        }
        
        emailField.text = "mzw4@cornell.edu"
        passwordField.text = "123"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        createLinedField(emailField)
        createLinedField(passwordField)
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
