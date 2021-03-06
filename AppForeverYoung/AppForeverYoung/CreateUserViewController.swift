//
//  CreateUserViewController.swift
//  AppForeverYoung
//
//  Created by Renato Tramontano on 17/02/17.
//  Copyright © 2017 iosparthenopedeveloper. All rights reserved.
//

import UIKit

class CreateUserViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet var typePersonPicker: UIPickerView!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var surname: UITextField!
    @IBOutlet var telephone: UITextField!
    @IBOutlet var buttonImagePerson: UIButton!
    @IBOutlet var imagePerson: UIImageView!
    @IBOutlet var age: UITextField!
    @IBOutlet weak var CreateButton: UIButton!
    @IBOutlet weak var riquadro1: UIImageView!
    
    let typePerson = ["Elderly", "Relative"]
    var person = String()
    let picker = UIImagePickerController()
    var datePickerView:UIDatePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        riquadro1.layer.cornerRadius = 15
        riquadro1.layer.masksToBounds = true
        riquadro1.layer.borderWidth = 2.0
        riquadro1.layer.borderColor = UIColor(hue: 0.7222, saturation: 0, brightness: 1, alpha: 0.25).cgColor
        
        CreateButton.layer.borderWidth = 1.0
        CreateButton.layer.borderColor = UIColor(white: 1.0, alpha: 0.7).cgColor
        CreateButton.layer.cornerRadius = 10
        
        picker.delegate = self
        person = typePerson[0]
        
        username.delegate = self
        password.delegate = self
        name.delegate = self
        surname.delegate = self
        telephone.delegate = self
        age.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // Solleva la view quando mostra la tastier
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2-50
            }
        }
    }
    
    // Riabassa la view quando la teatsiera sparisce
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height/2-50
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Hide keyboard when user touches outside kebord
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return typePerson.count
    }
    
    //MARK: UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return typePerson[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let attributedString = NSAttributedString(string: typePerson[row], attributes: [NSForegroundColorAttributeName : UIColor.white])
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        person = typePerson[row]
    }
    
    
    @IBAction func createAction(_ sender: Any) {
        let result = DataBase.createUser(username: username.text!, password: password.text!, name: name.text!, surname: surname.text!, telephone: telephone.text!, type: person, imagePerson: imagePerson.image!, age: age.text!)
        
        if result {
            let alertController = UIAlertController(title: "Successfully performed registration", message: "You have enrolled successfully", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  {(action:UIAlertAction) in
                self.performSegue(withIdentifier: "returnMain", sender: self)}))
            present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "No successfully performed registration", message: "You don't have enrolled successfully", preferredStyle: UIAlertControllerStyle.alert)
                
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler:  nil))
            present(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func controlUsername(_ sender: Any) {
        let result = DataBase.controlUsername(username: username.text!)
        
        if result == true {
            username.text = ""
            username.attributedPlaceholder = NSAttributedString(string:"existing username", attributes:[NSForegroundColorAttributeName: UIColor.red])
        }
    }
    
    @IBAction func controlTelephone(_ sender: Any) {
        let result = DataBase.controlTelephone(telephone: telephone.text!)
        
        if result == true {
            telephone.text = ""
            telephone.attributedPlaceholder = NSAttributedString(string:"existing telephone", attributes:[NSForegroundColorAttributeName: UIColor.red])
        }
    }
    
    
    @IBAction func addImageFromLibrary(_ sender: Any) {
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        //imagePerson.contentMode = .scaleAspectFit
        imagePerson.image = chosenImage
        buttonImagePerson.setTitle("", for: .normal)
        dismiss(animated:true, completion: nil)
    }
    
    
    @IBAction func selectDate(_ sender: UITextField) {
        // Data Picker
        self.datePickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        datePickerView.backgroundColor = UIColor.white
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        // Tool Bar
        let toolBar = UIToolbar()
        toolBar.barStyle = .blackOpaque
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 255/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        self.age?.inputAccessoryView = toolBar
        
        
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
       
    func doneClick() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .medium
        dateFormatter1.timeStyle = .none
        age?.text = dateFormatter1.string(from: datePickerView.date)
        self.age?.resignFirstResponder()
    }
    
    
    func cancelClick() {
        self.age?.resignFirstResponder()
    }

    func datePickerValueChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.none
        age?.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        super.viewWillAppear(animated)
    }
  
}
