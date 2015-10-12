//
//  SignupViewController.swift
//  BluetoothTest
//
//  Created by Mike Wang on 10/8/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController {

    let firebaseRef = Firebase(url:"https://fiery-heat-4470.firebaseio.com")
    
    let logoView = UIImageView()
    let titleView = UILabel()
    let tagline = UILabel()
    let backgroundImageView = UIImageView()
    
    let firstNameField = UITextField()
    let lastNameField = UITextField()
    let nameContainer = UIView()
    let emailField = UITextField()
    let passwordField = UITextField()
    let signupbutton = UIButton(type: UIButtonType.System) as UIButton
    let alreadyHaveAccountButton = UIButton(type: UIButtonType.System) as UIButton
    let descriptionText = UILabel()
    let errorText = UILabel()
    
    func createUser(sender: UIButton!) {
        if (validateFields()) {
            let email = emailField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            let password = passwordField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            
            firebaseRef.createUser(email, password: password,
                withValueCompletionBlock: { error, result in
                    if error != nil {
                        // There was an error creating the account
                        print("error creating account: \(error)")
                        self.errorText.text = "Error creating account. Sorry :)"
                    } else {
                        let uid = result["uid"] as? String
                        print("Successfully created user account with uid: \(uid)")
                        
                        self.errorText.text = ""
                        let VC = ViewController()
                        self.presentViewController(VC, animated: true, completion: nil)
                    }
            })
        }
    }
    
    func createUserCompletion(error: NSError!, result: [NSObject: AnyObject]!) {}
    
    func validateFields() -> Bool {
        return true
    }
    
    func alreadyHaveAccount(sender: UIButton!) {
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
        view.addSubview(blurEffectView)
        view.addSubview(logoView)
        view.addSubview(titleView)
        view.addSubview(tagline)
        nameContainer.addSubview(firstNameField)
        nameContainer.addSubview(lastNameField)
        view.addSubview(nameContainer)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signupbutton)
        view.addSubview(alreadyHaveAccountButton)
        view.addSubview(descriptionText)
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
        
        // Name fields
        nameContainer.translatesAutoresizingMaskIntoConstraints = false
        nameContainer.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(logoView.snp_bottom).offset(UIConstants.spacing2)
            make.centerX.equalTo(view.snp_centerX)
            make.width.equalTo(UIConstants.fieldWidth)
            make.height.equalTo(UIConstants.fieldHeight)
        }
        
        firstNameField.translatesAutoresizingMaskIntoConstraints = false
        firstNameField.textColor = UIColor.whiteColor()
        firstNameField.tintColor = UIColor.whiteColor()
        firstNameField.attributedPlaceholder = NSAttributedString(string: "First name", attributes: [NSForegroundColorAttributeName:UIConstants.fadedColor])
        firstNameField.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(nameContainer.snp_centerY)
            make.left.equalTo(nameContainer.snp_left)
            make.width.equalTo(UIConstants.fieldWidthSmall)
        }
        
        lastNameField.translatesAutoresizingMaskIntoConstraints = false
        lastNameField.textColor = UIColor.whiteColor()
        lastNameField.tintColor = UIColor.whiteColor()
        lastNameField.attributedPlaceholder = NSAttributedString(string: "Last name", attributes: [NSForegroundColorAttributeName:UIConstants.fadedColor])
        lastNameField.snp_makeConstraints { (make) -> Void in
            make.left.equalTo(firstNameField.snp_right).offset(UIConstants.spacing1)
            make.centerY.equalTo(firstNameField.snp_centerY)
            make.width.equalTo(UIConstants.fieldWidthSmall)
        }
        
        // Email field
        emailField.translatesAutoresizingMaskIntoConstraints = false
        emailField.textColor = UIColor.whiteColor()
        emailField.tintColor = UIColor.whiteColor()
        emailField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSForegroundColorAttributeName:UIConstants.fadedColor])
        emailField.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(nameContainer.snp_bottom).offset(UIConstants.spacing1)
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
        
        // Signup button
        signupbutton.translatesAutoresizingMaskIntoConstraints = false
        signupbutton.setTitle("Sign up", forState: .Normal)
        signupbutton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        signupbutton.backgroundColor = UIConstants.primaryColor
        signupbutton.layer.cornerRadius = 5
        signupbutton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(passwordField.snp_bottom).offset(UIConstants.spacing1)
            make.width.equalTo(UIConstants.fieldWidth)
        }
        signupbutton.addTarget(self, action: "createUser:", forControlEvents: UIControlEvents.TouchUpInside)
        
        descriptionText.translatesAutoresizingMaskIntoConstraints = false
        descriptionText.textColor = UIColor.redColor()
        descriptionText.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(signupbutton.snp_bottom).offset(UIConstants.spacing1)
            make.height.equalTo(UIConstants.fieldHeight)
            make.width.equalTo(UIConstants.fieldWidth)
        }
        
        errorText.translatesAutoresizingMaskIntoConstraints = false
        errorText.textColor = UIColor.redColor()
        errorText.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.top.equalTo(descriptionText.snp_bottom).offset(UIConstants.spacing1)
            make.height.equalTo(UIConstants.fieldHeight)
            make.width.equalTo(UIConstants.fieldWidth)
        }
        
        alreadyHaveAccountButton.translatesAutoresizingMaskIntoConstraints = false
        alreadyHaveAccountButton.setTitle("I already have an account", forState: .Normal)
        alreadyHaveAccountButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        alreadyHaveAccountButton.backgroundColor = UIColor.clearColor()
        alreadyHaveAccountButton.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(view.snp_centerX)
            make.bottom.equalTo(view.snp_bottom).offset(UIConstants.botMargin)
            make.width.equalTo(UIConstants.fieldWidth)
        }
        alreadyHaveAccountButton.addTarget(self, action: "alreadyHaveAccount:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createView()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        createLinedField(firstNameField)
        createLinedField(lastNameField)
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
