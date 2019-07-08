//
//  ViewController.swift
//  PickAndDisplayImage
//
//  Created by Kadisius, Pijus on 6/19/19.
//  Copyright © 2019 pk. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!

    // Define text field properties
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.00
    ]
    
    struct Meme {
        var topText: String
        var bottomText: String
        var originalImage: UIImage?
        var memedImage: UIImage?
    }
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let topPlaceholder = NSAttributedString(string: "TOP", attributes: [NSAttributedString.Key.strokeColor: UIColor.black,
                                                                         NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                         NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                                         NSAttributedString.Key.strokeWidth: -3.00])
        
        let bottomPlaceholder = NSAttributedString(string: "BOTTOM", attributes: [NSAttributedString.Key.strokeColor: UIColor.black,
                                                                            NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                                            NSAttributedString.Key.strokeWidth: -3.00])
        // Assign text field properties to top and bottom text fields
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.attributedPlaceholder = topPlaceholder
        topTextField.textAlignment = .center
        topTextField.delegate = self
        
        bottomTextField.defaultTextAttributes = memeTextAttributes;
        bottomTextField.attributedPlaceholder = bottomPlaceholder
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
    }
    
    // Disable camera button if camera is not available on device
    // Subscribe to keyboard notifications
    override func viewWillAppear(_ animated: Bool) {
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    // Function to save a meme
    // TODO: check requirements for this method
    func save() {
        let memedImage = generateMemedImage()
        // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
    }

    // TODO: check if the navbar and toolbar are actually being hidden and shown
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar and navbar
        navigationController?.setToolbarHidden(true, animated: false)
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        // Show toolbar and navbar
        navigationController?.setToolbarHidden(false, animated: false)
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        return memedImage
    }
    
    // Method to share meme
    // TODO: pass the created meme to this method
    @IBAction func share(_ sender: Any) {
        let memeToShare = generateMemedImage()
        if let myWebsite = NSURL(string: "") {
            let objectsToShare = [memeToShare, myWebsite] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = sender as? UIView
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    // Method for cancel button
    @IBAction func cancel(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
    }
}

// All `UIImagePickerControllerDelegate` methods here
extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // Pick image and close imagePickerController
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Close imagePickerController when cancel is pressed
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Pick image from album
    @IBAction func pickAnImageFromAlbum(_ sender:Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Pick image from camera (take image)
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

}

// All `UITextFieldDelegate` methods here
extension MemeEditorViewController: UITextFieldDelegate {
    // Hide keyboard on pressing return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        topTextField.resignFirstResponder()
        bottomTextField.resignFirstResponder()
        return true
    }
    
    // Functions to display and hide the keyboard
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        // only do this if the bottom text field is being edited
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}
