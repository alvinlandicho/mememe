//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Alvin Landicho on 5/15/15.
//  Copyright (c) 2015 Alvin Landicho. All rights reserved.
//


// Selecting a meme from the table or collection presents the Meme Detail View. Clicking on the  back arrow of the Meme Detail View presents the previous Sent Memes View, either the table or collection.

import UIKit

class MemeDetailViewController: UIViewController {

    var memeDetail: UIImage!
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = true
        self.detailImageView.image = memeDetail
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tabBarController?.tabBar.hidden = false
    }

    deinit {
        println("MemeDetailViewController Deallocated")
    }
}
