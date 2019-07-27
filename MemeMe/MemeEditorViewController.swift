import UIKit

class MemeEditorViewController: UIViewController {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet var shareButton: UIBarButtonItem!
    @IBOutlet weak var topNavBar: UINavigationBar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
    
    
    // Define text field properties
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        .strokeColor: UIColor.black,
        .foregroundColor: UIColor.white,
        .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        .strokeWidth: -3.00
    ]
    
    // Lifecycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField(topTextField, text: "TOP TEXT")
        setupTextField(bottomTextField, text: "BOTTOM TEXT")
    }
    
    func setupTextField(_ textField: UITextField, text: String) {
        let placeHolderAttributes = NSAttributedString(string: text, attributes: [NSAttributedString.Key.strokeColor: UIColor.black,
                                                                                   NSAttributedString.Key.foregroundColor: UIColor.white,
                                                                                   NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                                                                                   NSAttributedString.Key.strokeWidth: -3.00])
        textField.defaultTextAttributes = memeTextAttributes
        textField.attributedPlaceholder = placeHolderAttributes
        textField.textAlignment = .center
        textField.delegate = self
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
    func save() {
        // Create the meme
        let memedImage = generateMemedImage()
        _ = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imagePickerView.image!, memedImage: memedImage.memedImage)
    }

    func generateMemedImage() -> Meme {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        topNavBar.isHidden = true
        bottomToolbar.isHidden = true
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImageObject = Meme(top: topTextField.text!, bottom: bottomTextField.text!, image: imagePickerView.image!, memedImage: UIGraphicsGetImageFromCurrentImageContext()!)
        topNavBar.isHidden = false
        bottomToolbar.isHidden = false
        UIGraphicsEndImageContext()
        
        return memedImageObject
    }
    
    // Method to share meme
    @IBAction func share(_ sender: Any) {
        let memeToShare = generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memeToShare.memedImage as Any], applicationActivities: nil);
        self.present(activityView, animated: true, completion: nil)
        activityView.completionWithItemsHandler = {
            (activity, success, items, error) in
            if(success){
                self.dismiss(animated: true, completion: nil);
            }
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
        presentPickerViewController(source: .photoLibrary)
    }
    
    // Pick image from camera (take image)
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentPickerViewController(source: .camera)
    }
    
    func presentPickerViewController(source: UIImagePickerController.SourceType) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
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
