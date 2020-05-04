//
//  MemeViewController.swift
//  Meme 2.0
//
//  Created by Luis Vazquez on 22.04.2020.
//  Copyright © 2020 Alortechs. All rights reserved.
//

import UIKit

class MemeViewController: UIViewController{

    //MARK: IBOutlets
    @IBOutlet weak var topToolbar: UIToolbar!
    @IBOutlet weak var bottomToolbar: UIToolbar!
        
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var activityShareButton: UIBarButtonItem!
    
    @IBOutlet weak var textFieldTop: UITextField!
    @IBOutlet weak var textFieldBottom: UITextField!
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use negative strokeWidth if will be set foregroundColor as well. Otherwise, only the stroke is seen.
        let textAttributes: [NSAttributedString.Key: Any] = [
                         NSAttributedString.Key.strokeColor: UIColor.black,
                         NSAttributedString.Key.foregroundColor: UIColor.white,
                         NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
                         NSAttributedString.Key.strokeWidth:  -5.0
                     ]
        
        //Set ImageView Background
        imageView.backgroundColor = .black
        
        //Top Textfield Configuration
        configureText(textFieldTop, "TOP", textAttributes)
        //Bottom Textfield Configuration
        configureText(textFieldBottom, "BOTTOM", textAttributes)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Subscribe to any keyboard notification
        subscribeToKeyboardNotifications()
        
        //Disable Camera if the device has not got one
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        //Enable or disable share button if image is not set yet
        activityShareButton.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //Unsubscribe from any keyboard notifications when view will disappear
        unsubscribeFromKeyboardNotifications()
    }
    
    //MARK: configureText: Set textFields properties and attributes
    func configureText(_ textField: UITextField, _ text: String,_ textAttributes: [NSAttributedString.Key: Any]){
        textField.defaultTextAttributes = textAttributes
        textField.autocapitalizationType = .allCharacters
        textField.backgroundColor = UIColor.clear //Remove background from textField
        textField.text = text
        textField.borderStyle = .none //No border from textField
        textField.textAlignment = .center
        textField.delegate = self //Add ViewController as delegate of textfield
    }
    
    //MARK: pickImageFrom: Create Controller, Set Delegation, Picker Source and Present it
    func pickImageFrom(_ source: UIImagePickerController.SourceType) {
        //Create UIImagePickerController
        let controller = UIImagePickerController()
        //Add ViewController as the delegate of imagePickerController
        controller.delegate = self
        //Select PhotoLibrary as the picker interface to be displayed by the controller.
        controller.sourceType = source
        //Present the "UIImagePickerController"
        present(controller, animated: true, completion: nil)
    }


    //MARK:- UIButton Action: Open Photo Library (UIImagePickerController)
    @IBAction func pickFromAlbum(_ sender: Any) {
        pickImageFrom(.photoLibrary)
    }
    
    //MARK:- UIButton Action: Open Camera (UIImagePickerController)
    @IBAction func pickFromCamera(_ sender: Any) {
        pickImageFrom(.camera)
    }
    
    //MARK: - shareImage: Open Activity Pop Up and Share Meme
    @IBAction func shareImage(_ sender: Any){
        //Generate our memed image to share
        let imageToSave:UIImage = generateMemedImage()
        //define an instance of the ActivityViewController and pass the image
        let activityController = UIActivityViewController(activityItems: [imageToSave], applicationActivities: nil)
       
        //Completion handler
        activityController.completionWithItemsHandler = { (_, completed, _, _) in
            // If share activity was completed then save meme
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
            }
        }
        //Present the ActivityViewController
        present(activityController, animated: true, completion: nil)
    }
    
    //MARK:- KeyBoard Subscriber Notification
    func subscribeToKeyboardNotifications() {
        
        //Subscribe to keyboardWillShow(_:) notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        //Subscribe to keyboardWillHide(_:) notifications
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: -KeyBoard Unsubscriber Notification
    func unsubscribeFromKeyboardNotifications() {
        
        //Unsubscribe from keyboardWillShow(_:) notifications
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        //Unsubscribe from keyboardWillShow(_:) notifications
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    //MARK: - keyboardWillShow Function
    @objc func keyboardWillShow(_ notification:Notification) {
        /*Set view y value upper for keyboard to not hide the textfield and verify that
        it is only for the bottom textfield, if not both will push the view upper */
        if self.textFieldBottom.isEditing {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    //MARK: - keyboardWillHide Function
    @objc func keyboardWillHide(_ notification:Notification) {
        //Set view y value back to origin when keyboard will be dismissed
        //Can also be set as view.frame.origin.y = 0
        if self.textFieldBottom.isEditing {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    //MARK: - getKeyboardHeight Function : Get Keyboard Height from notification
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        //Get userInfo dictionary [AnyHashable : Any]?
        let userInfo = notification.userInfo
        // Get the keyboardSize attributes from dictionary
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        //Return height of the keyboard
        return keyboardSize.cgRectValue.height
    }
    
    //MARK: - save : Create a meme object with all its characteristics
    func save() {
       // Create the meme
        let meme = Meme(topText: textFieldTop.text!, bottomText: textFieldBottom.text!, originalImage: imageView.image!, userModifiedImage: generateMemedImage())
        
        //Add to the memes array in App Delegate
        (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
    }
    
    
    //MARK: - generateMemedImage: Generate a meme UIImage object with text and image together
    func generateMemedImage() -> UIImage {

        //Hide toolbar and navbar
        self.topToolbar.isHidden = true
        self.bottomToolbar.isHidden = true

        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        //Show toolbar and navbar
        self.topToolbar.isHidden = false
        self.bottomToolbar.isHidden = false

        return memedImage
    }
    
    //MARK: - cancelMemeSelected: Cancel user selected image
    @IBAction func cancelMemeSelected(_ sender: Any){
        //Reset the selected image
        self.imageView.image = nil
        
        //Reset the textFields back to default
        self.textFieldTop.text = "TOP"
        self.textFieldBottom.text = "BOTTOM"
        
        //Disable Share Button
        activityShareButton.isEnabled = false
        
        //Dismiss the modal view when cancel is pressed
        dismiss(animated: true, completion: nil)

    }
}

//MARK: - UIImagePickerControllerDelegate, UINavigationControllerDelegate Implementation
extension MemeViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    //Tells the delegate that the user picked a still image or movie.
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo:[UIImagePickerController.InfoKey : Any]){
       
        //Unwrap optional with the "originalImage" key containing the user's selected picture and downcast it as UIImage
        if let image = didFinishPickingMediaWithInfo[.originalImage] as? UIImage {
            //Set our UIImageView to the user chosen image
            imageView.image = image
            //After we know the user picked an image then enable the share button
            activityShareButton.isEnabled = true
        }
                
        //Dismiss the album picking view after the user selected the image
        dismiss(animated: true, completion: nil)
    }
    
    //Tells the delegate that the user cancelled the pick operation.
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //Dismiss the view after the user picked the image
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -- UITextFieldDelegate Implementation
extension MemeViewController: UITextFieldDelegate{
        
    //When a user taps inside a textfield, the default text should clear
    func textFieldDidBeginEditing(_ textField: UITextField) {
        //Erase the text if its only the default TOP and Bottom
        if textField.text == "TOP" || textField.text == "BOTTOM"{
            textField.text = ""
        }
    }
    //When a user presses return, the keyboard should be dismissed.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
}

