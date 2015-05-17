//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Alvin Landicho on 5/13/15.
//  Copyright (c) 2015 Alvin Landicho. All rights reserved.
//

/*

MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends. MemeMe also temporarily stores sent memes which users can browse in a table or a grid.

User Flow:

When the user first launches the app the Sent Memes View appears, and it will initially be empty. The user will click on the “+” button to open the Meme Editor View.


Selecting a meme from the table or collection presents the Meme Detail View. Clicking on the  back arrow of the Meme Detail View presents the previous Sent Memes View, either the table or collection.


The sent memes view displays recently sent memes. It has a bottom toolbar with tabs that allow the user to toggle between viewing sent memes in a table and viewing them in a grid. The top navigation bar has a title that reads “Sent Memes” and an add button in the right corner displaying Apple’s stock “Add” icon.

*/

import Foundation
import UIKit

class MemeTableViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
   
    var memes: [MemeModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        println("memes count: \(memes.count)" )
        
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
        
        println("memes table count: \(memes.count)" )
        
        self.tableView.reloadData()
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    //Mark: DataSource:
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTabCell") as! MemeTableViewCell
    
        let memepic = memes[indexPath.item]
        
        //set meme image and texts:
        cell.imageTabCell.image = memepic.memeImage
        cell.labelTop.text = memepic.upperText
        cell.labelBottom.text = memepic.lowerText
        
        return cell
    }
    
    /*Selecting a meme from the table or collection presents the Meme Detail View. Clicking on the  back arrow of the Meme Detail View presents the previous Sent Memes View, either the table or collection. */
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let nextController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        //Populate view controller with data
        let memeforDetail = memes [indexPath.item]
        nextController.memeDetail = memeforDetail.memeImage
        
        //Present the view controller using navigation
        self.navigationController!.pushViewController(nextController, animated: true)
    }
    
    deinit {
        println("MemeTableViewController Deallocated")
    }
       
}
