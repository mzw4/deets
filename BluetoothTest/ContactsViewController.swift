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
    
    var userProfiles: [UIImage] = [UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!,UIImage(named:"jonsnow.png")!]
    
    var label = UILabel()
    var nameArray = ["Jon Snow","Jon Snow","Jon Snow","Jon Snow","Jon Snow","Jon Snow","Jon Snow","Jon Snow"]
    var cityArray = ["Product Manager, IBM", "Product Manager, IBM","Product Manager, IBM", "Product Manager, IBM","Product Manager, IBM", "Product Manager, IBM","Product Manager, IBM", "Product Manager, IBM"]
    
    var connectionSwitch = true
    
    //    // Section buttons
    //    let segmentedControlView = UISegmentedControl(items: ["Contacts", "Pending", "Recommended"])
    //    let contactsButton = UIButton(type: UIButtonType.System)
    //    let pendingButton = UIButton(type: UIButtonType.System)
    //
    //    // Contacts View
    //    var contactsView = UICollectionView()
    //
    //    // Pending View
    //    var pendingView = UICollectionView()
    //
    //    // Recommended View
    //    var recommendedView = UICollectionView()
    //
    //    func changeSegment(sender: UISegmentedControl) {
    //        switch sender.selectedSegmentIndex
    //        {
    //        case 0:
    //            contactsView.hidden = false
    //            pendingView.hidden = true
    //            recommendedView.hidden = true
    //        case 1:
    //            contactsView.hidden = true
    //            pendingView.hidden = false
    //            recommendedView.hidden = true
    //        case 2:
    //            contactsView.hidden = true
    //            pendingView.hidden = true
    //            recommendedView.hidden = false
    //        default:
    //            break;
    //        }
    //        view.endEditing(true)
    //    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Contacts"

        
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
        
        let cellTitle = UILabel(frame: CGRectMake(0, cell.frame.height/3-15, cell.frame.width, cell.frame.height))
        let cellAddress = UILabel(frame: CGRectMake(0, cell.frame.height/3, cell.frame.width, cell.frame.height))
        let cellImage = UIImageView(frame: CGRectMake(cell.frame.width/4, cell.frame.height/4-15, cell.frame.width/2, cell.frame.height/2))
        
        
        cell.backgroundView = UIView()
        cell.backgroundColor = UIColor.blackColor();
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red:0/255.0, green:188.7/255.0, blue:255/255.0, alpha: 1).CGColor
        
        // Cell Title - To be changed to inherit from Firebase
        cellTitle.textAlignment = .Center
        cellTitle.font = UIFont.systemFontOfSize(14)
        cellTitle.textColor = UIColor.whiteColor()
        cell.backgroundView?.addSubview(cellTitle)
        
        
        // Cell Address - To be changed to inherit from Firebase
        cellAddress.textAlignment = .Center
        cellAddress.font = UIFont.systemFontOfSize(10)
        cellAddress.textColor = UIColor.whiteColor()
        cell.backgroundView?.addSubview(cellAddress)
        
        
        // Cell Image - To be changed to inherit from Firebase
        cellImage.image = UIImage(named: "jonSnow.png")
        cellImage.layer.borderWidth = 0.5
        cellImage.layer.cornerRadius = 50
        cellImage.layer.borderColor = UIColor.whiteColor().CGColor
        cellImage.clipsToBounds = true
        cellImage.contentMode = .ScaleAspectFill
        cell.backgroundView?.addSubview(cellImage)
        
        
        
        cellTitle.text = nameArray[indexPath.row]
        cellAddress.text = cityArray[indexPath.row]
        cellImage.image = userProfiles[indexPath.row]
        
        
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
