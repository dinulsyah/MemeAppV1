//
//  MemeEditorViewController.swift
//  MemeApp
//
//  Created by On The Way on 19/05/20.
//  Copyright © 2020 Dinulsyah. All rights reserved.
//
import Foundation
import UIKit

class MemeEditorViewController: UIViewController{
     
    // MARK: Outlets
    @IBOutlet weak var bottomToolbar: UIToolbar!
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var sharedButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    var keyboardType:Int? = nil
    
     // MARK: Enum for Configuring UI
    enum stateUI:String {
        case viewDidLoad = "viewDidLoad"
        case cancelApplication = "cancelApplication"
        case hideToolbar = "hideToolbar"
        case showToolbar = "showToolbar"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(stateUI.viewDidLoad.rawValue)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: Pick an Image from Gallery
    @IBAction func pickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: Pick an Image from Camera
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cancelApplication(_ sender:Any){
        configureUI(stateUI.cancelApplication.rawValue)
    }
    
    @IBAction func sharedActivity(_ sender: Any) {
        // Create the meme
        let memedImage = generateMemedImage()
        
        // Save the meme into struct
        func save() {
            _ = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage)
        }
        
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityView.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            // User not completed activity
            if !completed {
                return
            }
            // User completed activity
            save()
        }
        present(activityView, animated: true, completion: nil)
    }
    
    func generateMemedImage() -> UIImage {
        var memedImage:UIImage?
        
        func createImageContext(){
            UIGraphicsBeginImageContext(self.view.frame.size)
            view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
            memedImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        // Hide toolbar and navbar
        configureUI(stateUI.hideToolbar.rawValue)
        // Render view to an image
        createImageContext()
        // Show toolbar and navbar
        configureUI(stateUI.showToolbar.rawValue)

        return memedImage!
    }
    
    // MARK: All Condition & Action for Configuring UI
    
    func configureUI(_ state:String){
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let textConfig = textAttributes.init(strokeColor: UIColor.black, foregroundColor: UIColor.white, font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, strokeWidth: -4.5, paragragraphStyle:paragraph)
        
        switch state {
        case "viewDidLoad":
            topTextField.defaultTextAttributes = textConfig.meme
            topTextField.text = "TOP"
            topTextField.delegate = self
            bottomTextField.text = "BOTTOM"
            bottomTextField.defaultTextAttributes = textConfig.meme
            bottomTextField.delegate = self
            sharedButton.isEnabled = false
        case "cancelApplication":
            topTextField.text = "TOP"
            bottomTextField.text = "BOTTOM"
            imagePickerView.image = UIImage()
            sharedButton.isEnabled = false
        case "hideToolbar":
            topToolbar.isHidden = true
            bottomToolbar.isHidden = true
        case "showToolbar":
            topToolbar.isHidden = false
            bottomToolbar.isHidden = false
        default:
            return
        }
    }
}

// MARK: Handling Keyboard Position

extension MemeEditorViewController{
    @objc func keyboardWillShow(_ notification:Notification) {
           if let keyboardType = keyboardType{
               if keyboardType == 1{
                       view.frame.origin.y -= getKeyboardHeight(notification)
               }
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
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: Handling Picking an Image from
extension MemeEditorViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
                sharedButton.isEnabled = true
                imagePickerView.image = image
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MemeEditorViewController:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardType = textField.tag
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
