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
    let logoContainer = UIView()
    let logoView = UIImageView()
    let titleView = UILabel()
    let tagline = UILabel()
    let backgroundImageView = UIImageView()
    
    let emailField = UITextField()
    let passwordField = UITextField()
    let signinbutton = UIButton(type: UIButtonType.System) as UIButton
    let forgotPassButton = UIButton(type: UIButtonType.System) as UIButton
    let backButton = UIButton(type: UIButtonType.System) as UIButton
    let errorText = UILabel()
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    func loginUser(sender: UIButton!) {
        spinner.startAnimating()
        if (validateFields()) {
            DataHandler.loginUser(emailField.text!, password: passwordField.text!, completion: { error, authData in
                self.spinner.stopAnimating()
                if error != nil {
                    // There was an error logging in to this account
                    print("Error logging in! \(error)")
                    self.errorText.text = "Invalid email or password :("
                } else {
                    // We are now logged in
                    let email = authData.providerData["email"]
                    print("\(authData) logged in with email \(email) and id \(authData.uid)")
                    
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    self.presentViewController(appDelegate.tabBarController, animated: true, completion: nil)
//                        appDelegate.window?.rootViewController = appDelegate.tabBarController
                    
                    // Set the user id for the session
                    NSUserDefaults.standardUserDefaults().setObject(authData.uid, forKey: "userId")
                    NSUserDefaults.standardUserDefaults().synchronize()
                }
            })
        }
    }
    
    func validateFields() -> Bool {
        return true
    }
    
    func handleForgotPassword(sender: UIButton!) {
        print("Forgot password!")
    }
    
    func handleBack(sender: UIButton!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func createView() {
        view.backgroundColor = UIColor.blackColor()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        view.addSubview(backgroundImageView)
        view.addSubview(blurEffectView)
        logoContainer.addSubview(logoView)
        logoContainer.addSubview(titleView)
        view.addSubview(logoContainer)
        view.addSubview(tagline)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signinbutton)
        view.addSubview(forgotPassButton)
        view.addSubview(backButton)
        view.addSubview(errorText)
        view.addSubview(spinner)
        
        spinner.hidesWhenStopped = true
                
        // Set the background image
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = UIViewContentMode.ScaleAspectFill
        backgroundImageView.image = UIImage(named: "background2.png")!
        backgroundImageView.alpha = 0.5
        backgroundImageView.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view.snp_center)
            make.size.equalTo(view.snp_size)
        }
        
        // Logo and title
        logoView.translatesAutoresizingMaskIntoConstraints = false
        logoView.frame = CGRectMake(logoView.frame.origin.x, logoView.frame.origin.y, 100, 50)
        logoView.contentMode = UIViewContentMode.ScaleAspectFit
        logoView.image = UIImage(named: "logo.png")
        logoView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(logoContainer.snp_left)
            make.centerY.equalTo(logoContainer.snp_centerY)
            make.height.equalTo(UIConstants.logoHeightLarge)
            make.width.equalTo(UIConstants.logoWidthLarge)
        }
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = "Cohesve"
        titleView.textColor = UIColor.whiteColor()
        titleView.font = UIFont(name: UIConstants.fontLight, size: CGFloat(UIConstants.fontBig))
        titleView.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(logoView.snp_right).offset(UIConstants.spacing1)
            make.centerY.equalTo(logoContainer.snp_centerY)
        }
        titleView.layoutIfNeeded()
        logoContainer.translatesAutoresizingMaskIntoConstraints = false
        logoContainer.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(view.snp_top).offset(UIConstants.topMargin)
            make.width.equalTo(UIConstants.logoWidthLarge + UIConstants.spacing1 + Int(titleView.frame.width))
            make.height.equalTo(logoView.snp_height)
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
        
        // Error text
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.text = " "
        errorText.sizeToFit()
        errorText.textColor = UIConstants.errorColor
        errorText.font = UIFont(name: titleView.font.fontName, size: CGFloat(UIConstants.fontSmall))
        errorText.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(passwordField.snp_bottom).offset(UIConstants.spacing0)
            make.width.equalTo(UIConstants.fieldWidth)
//            make.height.equalTo(UIConstants.fieldWidth)
        }
        
        // Signin button
        signinbutton.translatesAutoresizingMaskIntoConstraints = false
        signinbutton.setTitle("Sign In", forState: .Normal)
        signinbutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signinbutton.backgroundColor = UIConstants.primaryColor
        signinbutton.layer.cornerRadius = 5
        signinbutton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(errorText.snp_bottom).offset(UIConstants.spacing1)
            make.width.equalTo(UIConstants.fieldWidth)
        }
        signinbutton.addTarget(self, action: "loginUser:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Forgot password button
        forgotPassButton.translatesAutoresizingMaskIntoConstraints = false
        forgotPassButton.setTitle("Forgot your password?", forState: .Normal)
        forgotPassButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        forgotPassButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(signinbutton.snp_left)
            make.top.equalTo(signinbutton.snp_bottom).offset(UIConstants.spacing0)
        }
        forgotPassButton.addTarget(self, action: "handleForgotPassword:", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Back button
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", forState: .Normal)
        backButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        backButton.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(signinbutton.snp_left)
            make.top.equalTo(forgotPassButton.snp_bottom).offset(UIConstants.spacing0)
        }
        backButton.addTarget(self, action: "handleBack:", forControlEvents: UIControlEvents.TouchUpInside)
        
        emailField.text = "mzw4@cornell.edu"
        passwordField.text = "123"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
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
