//
//  ViewController.swift
//  Instant Gram
//
//  Created by John Clem on 12/12/15.
//  Copyright © 2015 learnswift.io. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate {

    var photos = [UIImage]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func takePhoto(sender: AnyObject) {
        print("taking a photo")
        // Create a image picker
        let imagePicker = UIImagePickerController()
        // Set the source type
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        // Assign the delegate
        imagePicker.delegate = self
        // Present the view controller
        self.presentViewController(imagePicker, animated: true) {
            print("image picker presented")
        }
    }
    
    //MARK: Image Picker Delegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        print("picked an image")
        // dismiss the image picker
        picker.dismissViewControllerAnimated(true, completion: nil)
        // Convert to CIImage
        guard let ciImage = CIImage(image: image) else { return }
        // Create / Configure CIFilter
        guard let filter = CIFilter(name: "CIPhotoEffectNoir") else { return }
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        // Convert output image to UIImage
        guard let outputImage = filter.outputImage else { return }
        let filteredImage = UIImage(CIImage: outputImage)
        // display the filtered image
        self.photos.append(filteredImage)
        // reload the collectionview data source
        self.collectionView.reloadData()
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("cancelled image picker")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: UICollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.photos.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // De-queue a cell
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! PhotoCell
        // Configure the cell
        let photo = self.photos[indexPath.item]
        cell.imageView.image = photo
        // Return the cell
        return cell
    }
    
    //MARK: UICollectionView Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Pull the selected photo out of the array
        let photo = self.photos[indexPath.item]
        // Create a UIActivityViewController
        let activityController = UIActivityViewController(activityItems: [photo], applicationActivities: nil)
        // Present the activity controller
        self.presentViewController(activityController, animated: true, completion: nil)
    }
    
}

class PhotoCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
}