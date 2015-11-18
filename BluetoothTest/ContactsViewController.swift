//
//  ContactsViewController.swift
//  BluetoothTest
//
//  Created by Julian Ferdman on 10/26/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {

    var collectionView : UICollectionViewFlowLayout = UICollectionViewFlowLayout()   // Initialization
    //    let firebaseRef = Firebase(url:"https://fiery-heat-4470.firebaseio.com/")
    //    let userRef = Firebase(url: "https://<your-firebase-app>.firebaseio.com/users")
    //    let itemsRef = rootRef.childByAppendingPath("users")
    //    let cityRef = itemsRef.childByAppendingPath("city")
    //    let dataSource: FirebaseCollectionViewDataSource!
    
    var userProfiles: [UIImage] = [UIImage(named:"jonsnow.png")!,UIImage(named:"jaime.png")!,UIImage(named:"littlefinger.png")!,UIImage(named:"tyrion.png")!,UIImage(named:"trump.png")!,UIImage(named:"daenerys.png")!,UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!]
    
    var label = UILabel()
    var nameArray = ["Jon Snow","Jaime Lannister","Littlefinger","Tyrion Lannister","Donald Trump","Daenerys Stormborn","Jon Snow","Jon Snow"]
    var cityArray = ["Product Manager, IBM", "Product Manager, IBM","Product Manager, IBM", "Product Manager, IBM","Product Manager, IBM", "Product Manager, IBM","Product Manager, IBM", "Product Manager, IBM"]
    
    var connectionSwitch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "Modal")
        
        let flowLayout:UICollectionViewFlowLayout = UICollectionViewFlowLayout();
        flowLayout.itemSize = CGSize(width: self.view.frame.size.width/2, height: self.view.frame.size.height/2)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        for c in User.currentContacts.values {
            print(c.name)
        }
        
        let collectionView:UICollectionView? = UICollectionView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height), collectionViewLayout: flowLayout);
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell");
        collectionView?.delegate = self;
        collectionView?.dataSource = self;
        collectionView?.backgroundColor = UIColor(red:0/255.0, green:0/255.0, blue:0/255.0, alpha: 1.0);
        
        var user: User!
        if ProfileViewController.userIdShow == nil {
            ProfileViewController.userIdShow = User.currentUser.userId
        }
        
        let uid = ProfileViewController.userIdShow!
        if uid == User.currentUser.userId {
            user = User.currentUser
        } else {
            User.getUserInfo(uid, completion: { userObj in
                user = userObj
                
            })
        }

        
        self.view.addSubview(collectionView!);
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell:UICollectionViewCell=collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as UICollectionViewCell;
        
        let cellTitle = UILabel(frame: CGRectMake(0, cell.frame.height/3-20, cell.frame.width, cell.frame.height))
        let cellAddress = UILabel(frame: CGRectMake(0, cell.frame.height/3, cell.frame.width, cell.frame.height))
        let cellImageIcon = UIImageView(frame: CGRectMake(cell.frame.width/4, cell.frame.height/4-25, cell.frame.width/2, cell.frame.height/2))
        let blurEffectDark = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let cellBackgroundView = UIVisualEffectView(effect: blurEffectDark)
        let cellImage = UIImageView(frame: CGRectMake(-10, -10, cell.frame.width*1.2, cell.frame.height*1.2))

        cell.clipsToBounds = true
        
        cell.backgroundView = UIView()
        cell.backgroundColor = UIColor.blackColor();
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor(red:255/255.0, green:255/255.0, blue:255/255.0, alpha: 0.1).CGColor
        

        
        
        // Cell Image - To be changed to inherit from Firebase
        cellImage.alpha = 0.55
//        cellImage.layer.cornerRadius = cell.frame.width/4
        cellImage.layer.borderColor = UIColor.whiteColor().CGColor
        cellImage.clipsToBounds = true
        cellImage.contentMode = .ScaleAspectFill
        cell.backgroundView?.addSubview(cellImage)
        
        cell.backgroundView?.addSubview(cellBackgroundView)
        cellBackgroundView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(cell.snp_width)
            make.height.equalTo(cell.snp_height)
            make.center.equalTo(cell.snp_center)
        }
        
        cellImageIcon.layer.cornerRadius = cell.frame.width/4
        cellImageIcon.clipsToBounds = true
        cellImageIcon.contentMode = .ScaleAspectFill
        cell.backgroundView?.addSubview(cellImageIcon)
        
        // Cell Title - To be changed to inherit from Firebase
        cellTitle.textAlignment = .Center
        cellTitle.font = UIFont.systemFontOfSize(15)
        cellTitle.textColor = UIColor.whiteColor()
        cell.backgroundView?.addSubview(cellTitle)
        
        
        // Cell Address - To be changed to inherit from Firebase
        cellAddress.textAlignment = .Center
        cellAddress.font = UIFont.systemFontOfSize(11)
        cellAddress.textColor = UIColor.whiteColor()
        cellAddress.alpha = 0.8
        cell.backgroundView?.addSubview(cellAddress)
        
        
        cellTitle.text = nameArray[indexPath.row]
        cellAddress.text = cityArray[indexPath.row]
        cellImage.image = userProfiles[indexPath.row]
        cellImageIcon.image = userProfiles[indexPath.row]
        

        print(indexPath.row)
        return cell;
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if nameArray.count > 0 {
            return nameArray.count;
        }
        return 0;
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSizeMake(collectionView.frame.size.width/2, collectionView.frame.size.width/2);
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets
    {
        return UIEdgeInsetsZero; //top,left,bottom,right
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        //        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        //        //cell!.layer.backgroundColor = UIColor.redColor().CGColor
        //        print(indexPath.row)
        //        //LINK TO PROFILE VIEW
        //        print(cell)
        print("You selected cell #\(indexPath.item)!")
    }
}
