//
//  ViewController.swift
//  Instant Gram
//
//  Created by John Clem on 12/11/15.
//  Copyright © 2015 learnswift.io. All rights reserved.
//

import UIKit
import Social

// Add the necessary protocols for the photo picker and collection view
class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    // Stores the photos for the collection view
    var photos = [UIImage]()
    // The collection view displays all of the photos
    @IBOutlet weak var collectionView: UICollectionView!
    
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
                // Apply the noir filter to the image
                let filteredImage = self.filterImage(editedImage)
                // Add the edited image to the photos array
                self.photos.append(filteredImage)
            } else {
                // Add the original image to the photos array
                self.photos.append(image)
            }
            // Reload the collectionview data source so the new image displays
            self.collectionView.reloadData()
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        // Dismiss the image picker
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func filterImage(image: UIImage) -> UIImage {
        // Convert the UIKit Image into a CoreImage Image
        guard let ciImage = CIImage(image: image) else { return image }
        // Create the Core Image filter
        guard let ciFilter = CIFilter(name: "CIPhotoEffectNoir") else { return image }
        // Configure the filter 
        ciFilter.setValue(ciImage, forKey: kCIInputImageKey)
        // Get the output Core Image image
        guard let outputImage = ciFilter.outputImage else { return image }
        // Create a new UIImage from the filtered CIImage
        let filteredImage = UIImage(CIImage: outputImage)
        // Return the filtered image
        return filteredImage
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // Create a collectionview cell using our string identifier from the storyboard
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
        // Pull out the image for this row
        let image = self.photos[indexPath.row]
        // Assign the image to the cell
        cell.imageView.image = image
        // Return the configured cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // We want one cell for each photo
        return self.photos.count
    }
    
    //MARK: UICollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Pull the selected photo from the array 
        let image = self.photos[indexPath.row]
        // Create the photo sharing view controller
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        // Present the activity controller
        self.presentViewController(activityController, animated: true, completion: nil)
    }
}

class PhotoCell: UICollectionViewCell {
    // Displays the image for the cell
    @IBOutlet weak var imageView: UIImageView!
}

