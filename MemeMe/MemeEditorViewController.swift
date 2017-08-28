//
//  ViewController.swift
//  pickerPresentation
//
//  Created by grace montoya on 6/24/16.
//  Copyright © 2016 grace montoya. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
    
    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    let textFieldDelegate = TextFieldDelegate()
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -3.0
    ] as [String : Any]
    
    override var prefersStatusBarHidden : Bool {
        return true     // status bar should be hidden
    }
    
//view DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextField("TOP", textField: topTextField)
        setTextField("BOTTOM", textField: bottomTextField)
        
        shareButton.isEnabled = false
        saveButton.isEnabled = false
    }
    
    func setTextField(_ initText:String, textField:UITextField){
        textField.text = initText
        textField.delegate = textFieldDelegate
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        
    }
    
//view WILL APPEAR
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)    
    }
    
//view WILL DISAPPEAR
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
//SUBSCRIBE TO KEYBOARD NOTIFICATIONS
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow(_:)),name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }
    
//UNSUBSCRIBE TO KEYBOARD NOTIFICATIONS
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name:
            NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
//KEYBOARD WILL SHOW
    func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y =  getKeyboardHeight(notification) * -1
        }
    }
    
//KEYBOARD WILL HIDE
    func keyboardWillHide(_ notification: Notification) {
        if bottomTextField.isFirstResponder {
            self.view.frame.origin.y = 0
        }
    }
    
// get keyboard height
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
// IMAGE PICKER DELEGATE METHODS
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        if let image = info[ UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            shareButton.isEnabled = true
            saveButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
        
    }
    
  
//LAUNCHING IMAGE PICKER FROM THE BUTTONS
    
    @IBAction func pickAnImage(_ sender: AnyObject) {
        setUpImagePickerButtons(UIImagePickerControllerSourceType.photoLibrary)
        
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        setUpImagePickerButtons(UIImagePickerControllerSourceType.camera)
    
    }
    
    func setUpImagePickerButtons(_ picker: UIImagePickerControllerSourceType){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = picker
        imagePickerController.allowsEditing = true
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    
    //SAVE MEME
    
     func saveMeme() {
        //Create the meme
        let meme = Meme(topTextField : topTextField.text!, bottomTextField : bottomTextField.text!, originalImage: imagePickerView.image!, memedImage:generateMemedImage())
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
        
    }
    
    //GENERATE MEMED IMAGE
    func generateMemedImage() -> UIImage
    {
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        //  Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        return memedImage
    }
    
    //SHARE MEME BUTTON
    @IBAction func shareMeme(_ sender: AnyObject) {
        // generate a memed image
        let meme = generateMemedImage()
        // define an instance of the ActivityViewController
        // pass the ActivityViewController a memedImage as an activity item
        let activity = UIActivityViewController(activityItems: [meme], applicationActivities: nil)
        // present the ActivityViewController
        present(activity, animated: true, completion: nil)
        
        activity.completionWithItemsHandler =  { activity, success, items, error in
            if success {
               self.saveMeme()
                 self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //CANCEL BUTTON
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //SAVE BUTTON
    
    @IBAction func saveButton(_ sender: UIBarButtonItem) {
      saveMeme()

    }
    
    //END
}

