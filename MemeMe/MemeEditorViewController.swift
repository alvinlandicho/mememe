//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Alvin Landicho on 5/13/15.
//  Copyright (c) 2015 Alvin Landicho. All rights reserved.
//

/*
MemeMe is a meme-generating app that enables a user to attach a caption to a picture from their phone. After adding text to an image chosen from the Photo Album or Camera, the user can share it with friends. MemeMe also temporarily stores sent memes which users can browse in a table or a grid.

In the Meme Editor View, when the user clicks on the “Album” button, an Image Picker is presented, making it possible to choose an image from the Photo Album. If there is a camera available on the device, pressing the camera button launches the camera, and a newly snapped photo can be chosen for the meme. If a camera is not available on the device, the camera button is disabled.
After an image is chosen, the image picker is dismissed, allowing text to be entered into the top and bottom text fields of the editor. When a user clicks inside one of the text fields, the default text disappears and the keyboard slides up. When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed.
When the user presses the share button, Apple’s stock Activity View appears, displaying several options for sharing the meme. After an option is chosen, the Activity View is dismissed and the Sent Memes View appears. The Sent Memes View also appears upon pressing the “Cancel” button.
*/

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    //Variable declaration globbally
    var meme: MemeModel!
    var memeImage: UIImage!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Helvetica-Bold", size: 30)!,
        NSStrokeWidthAttributeName :5]
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        topTextField.delegate = self
        bottomTextField.delegate = self
        topTextField.text = "TOP"
        topTextField.textAlignment = NSTextAlignment.Center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = NSTextAlignment.Center
        
        shareButton.enabled = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.tabBarController?.tabBar.hidden = true
        
        //If a camera is not available on the device, the camera button is disabled.
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        
        super.viewWillAppear(animated)
        // Subscribe to keyboard notifications to allow the view to raise when necessary
        self.subscribeToKeyboardNotifications()
        self.subscribeToKeyboardWillHideNotifications()

    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
        
        self.unsubscribeFromKeyboardNotifications()
        self.unsubscribeToKeyboardWillHideNotifications()
        
    }

    /*After an image is chosen, the image picker is dismissed, allowing text to be entered into the top and bottom text fields of the editor. When a user clicks inside one of the text fields, the default text disappears and the keyboard slides up. When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed.*/
    
    func textFieldDidBeginEditing(textField: UITextField) {
               
        if topTextField.isFirstResponder() && topTextField.text == "TOP" {
            topTextField.text = ""
        }
        
        if bottomTextField.isFirstResponder() && bottomTextField.text == "BOTTOM" {
            bottomTextField.text = ""
        }
    }
    
    
    //When the user finishes entering text and presses return, the keyboard is dismissed and the new meme is displayed.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        return true
    }
    
    //Mark: Keyboard Notifications:
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func subscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardWillHideNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide (notification: NSNotification) {
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }

    
    /*In the Meme Editor View, when the user clicks on the “Album” button, an Image Picker is presented, making it possible to choose an image from the Photo Album. If there is a camera available on the device, pressing the camera button launches the camera, and a newly snapped photo can be chosen for the meme. If a camera is not available on the device, the camera button is disabled.*/
    
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        shareButton.enabled = true
    }
    
    
    /* When the user presses the share button, Apple’s stock Activity View appears, displaying several options for sharing the meme.*/
    
    @IBAction func shareButton(sender: AnyObject) {
        
        let image = generateMemeImage()
        let nextController = UIActivityViewController (activityItems: [image], applicationActivities: nil)
        self.presentViewController(nextController, animated: true, completion: nil)
        
        nextController.completionWithItemsHandler = { (activity, success, items, error) in
            println("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            
            if success == true {
                println("saved it")
                self.save()
            }
            self.navigationController!.popToRootViewControllerAnimated(true)
        }
    }
    
    
    // Create a meme object and add it to the memes array
    
    func save () {
        // Update the meme
        meme = MemeModel(upperText: topTextField.text, lowerText: bottomTextField.text, originalImage: imagePickerView.image!, memeImage: generateMemeImage())
        
        // Add it to the memes array in the AppDelegate
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
        println("saved")
    }
    
    
    // Create a UIImage that combiness an image context to render the view hierarchy as UIImage
    
    func generateMemeImage () ->UIImage {
        // render view to an image
        
        // TODO: Hide toolbar and navbar
        self.navigationController?.setToolbarHidden(true, animated: true)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        toolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // TODO: Show toolbar and navbar
        self.navigationController?.setToolbarHidden(false, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        toolBar.hidden = false
        
        println("generate meme")
        return memeImage
    }
    
    
    // The Sent Memes View also appears upon pressing the “Cancel” button.
    @IBAction func cancelButton(sender: AnyObject) {
        
        println("cancelled")
        self.navigationController!.popToRootViewControllerAnimated(true)
    }
    
    
    deinit {
        println("MemeEditorViewController Deallocated")
    }
    
    

}

