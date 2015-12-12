//
//  ViewController.swift
//  Instant Gram
//
//  Created by John Clem on 12/11/15.
//  Copyright © 2015 learnswift.io. All rights reserved.
//

import UIKit

// Add the necessary protocols for the photo picker
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // Stores the photos for the collection view
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(sender: UIButton!) {
        // Create an image picker controller
        let photoPicker = UIImagePickerController()
        // Configure the photo picker to use the camera
        photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
        // Enable editing (for a 1:1 aspect ratio image)
        photoPicker.allowsEditing = true
        // Assign the delegate
        photoPicker.delegate = self
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        // Dismiss the image picker
        picker.dismissViewControllerAnimated(true) { () -> Void in
            // Unwrap the edited image from the editingInfo dictionary
            if let editedImage = editingInfo?[UIImagePickerControllerEditedImage] as? UIImage {
                // Add the edited image to the photos array
                self.photos.append(editedImage)
            } else {
                // Add the original image to the photos array
                self.photos.append(image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the image picker
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
}

