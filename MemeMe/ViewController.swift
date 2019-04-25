//
//  ViewController.swift
//  MemeMe
//
//  Created by SAM on 11/22/18.
//  Copyright © 2018 SAM. All rights reserved.
//

import UIKit
class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate ,UITextFieldDelegate{
   // NSObject, UITextFieldDelegate
//class ViewController: UIViewController
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextfield: UITextField!
    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var bottomBar: UIToolbar!
    @IBOutlet weak var shareBotton: UIBarButtonItem!
   // @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    let textAtt = attribute()
    var selectedTextField: UITextField?  //fake text field :) .. just help in code

    var memedImage = UIImage()
    var meme:Meme!

    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.topTextField.delegate = self
        //self.bottomTextfield.delegate = self
        //topTextField.defaultTextAttributes = textAtt.memeTextAttributes
        //topTextField.textAlignment = .center
       // topTextField.contentVerticalAlignment = .top
       // bottomTextfield.defaultTextAttributes = textAtt.memeTextAttributes
       // bottomTextfield.textAlignment = .center
       // bottomTextfield.contentVerticalAlignment = .top
        configureText11(topTextField, defaultText1: "TOP")
        configureText11(bottomTextfield, defaultText1: "Bottom")
        shareBotton.isEnabled = false
        }
    
    override func viewWillAppear(_ animated: Bool) {
        // subscribe to keyboard notifications
        subscribeToKeyboardNotifications()
        //hide nav bar
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // unsubscribe from keyboard functions
        unsubscribeFromKeyBoardNotifications()
    
        
}
    
    func configureText11(_ textField: UITextField,  defaultText1: String) {
        // TODO:- code to configure the textField
        textField.delegate = self
        textField.defaultTextAttributes = textAtt.memeTextAttributes
        textField.textAlignment = .center
        textField.contentVerticalAlignment = .top
        textField.text = defaultText1
        
    }
    
    
    func fromAlbumOrCamera(source: UIImagePickerControllerSourceType) {
        let imagePicker1 = UIImagePickerController()
        imagePicker1.delegate = self
        imagePicker1.sourceType = source
        shareBotton.isEnabled=true
        present(imagePicker1, animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func pickAnImage(_ sender:Any) {
        /*let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
        shareBotton.isEnabled=true*/
        fromAlbumOrCamera(source: .photoLibrary)
        }
   
    //thos func Tells the delegate that the user picked a still image or movie to show the image that i picked.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[/* TODO: Dictionary Key Goes Here */UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)}

    @IBAction func cameraButton(_ sender: Any) {
        fromAlbumOrCamera(source: .camera)
        }
    
    
    // MARK: - save the edited photo
    func save(memedImage: UIImage) {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextfield.text!, originalImage: imagePickerView.image, memeImage: memedImage)
        self.meme = meme
        //(UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    @IBAction func shareBotton(_ sender: Any) {
        let memeToShare = generateMemedImage()
        let activity = UIActivityViewController(activityItems: [memeToShare], applicationActivities: nil)
        activity.completionWithItemsHandler = { (activity, success, items, error) in
            
            if success {
                self.save(memedImage: memeToShare)
            }
        }
        present(activity, animated: true, completion:nil)
    }
    
    func generateMemedImage() -> UIImage {
        
        // TODO: Hide toolbar and navbar..written in view will appear
       
        self.topBar.isHidden = true
        self.bottomBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        /// TODO: Show toolbar and navbar..writen in view willdisappear
        self.topBar.isHidden = false
        self.bottomBar.isHidden = false
        return memedImage
    }
    
// MARK: - Keyboard Functions
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    //show and hide keyboard notification ... when show and when hide in the first
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let text = selectedTextField {
            if text == bottomTextfield {
                self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    //// MARK: - remove notifications
    func unsubscribeFromKeyBoardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
       

    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        selectedTextField = textField
        if textField.text == "TOP" || textField.text == "Bottom" {
            textField.text = ""
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        selectedTextField = nil
        if textField == topTextField && textField.text! == "" {
            textField.text = "TOP"
        }
        if textField == bottomTextfield && textField.text! == "" {
            textField.text = "Bottom"
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

}
    /* func subscribeToKeyboardNotifications() {
    
   // NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.KeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)

    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
     
    
    
     
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
      //  bottomTextfield.resignFirstResponder()
        return true
    }
    // function to move the view and its contents up when the keyboard is shown
    @objc func KeyboardWillShow(notification: Notification) {
        if bottomTextfield.isFirstResponder{
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    // function that moves the view and its contents back down when the keyboard is hidden
    func keyboardWillHide(notification: Notification) {
        if bottomTextfield.isFirstResponder || bottomTextfield.resignFirstResponder() || self.view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
}

func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
 {
 if let image = info[UIImagePickerControllerOriginalImage] as? UIImage
 {
 myImageView.image = image
 }
 else
 {
 //Error message
 }
 
 self.dismiss(animated: true, completion: nil)
 }
 */


