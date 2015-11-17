//
//  SettingsViewController.swift
//  BluetoothTest
//
//  Created by Vivek Sudarsan on 11/17/15.
//  Copyright © 2015 Vivek Sudarsan. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let settingsTable = UITableView()
    
    let settingsTitles = ["My Account","Notifications","Privacy"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blackColor()
        view.addSubview(settingsTable)
        
        navigationController?.navigationBar.barStyle = UIBarStyle.BlackTranslucent
        navigationItem.title = "Settings"
        
        settingsTable.dataSource = self
        settingsTable.delegate = self
        createView()
        
        // Do any additional setup after loading the view.
    }
    
    func createView(){
        settingsTable.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(view.snp_width)
            make.height.equalTo(view.snp_height)
        }
        settingsTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        settingsTable.backgroundColor = UIColor.clearColor()
        settingsTable.separatorColor = UIColor.blackColor()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor(white: 1.0, alpha: 0.1)
        cell.textLabel!.text = settingsTitles[indexPath.row]
        cell.textLabel!.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont.systemFontOfSize(15)
        
        
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return " "
    }
    
    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.contentView.backgroundColor = UIColor.blackColor()
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsTitles.count
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
