//
//  SignupViewController.swift
//  EventsAppUIKit
//
//  Created by Виталий on 06.06.2023.
//

import UIKit
import CoreData

class SignupViewController: UIViewController {
    
    
    @IBOutlet weak var passwordtext: UITextField!
    @IBOutlet weak var verifyPasswordText: UITextField!
    @IBOutlet weak var mailtext: UITextField!
    @IBOutlet weak var nametext: UITextField!
    @IBOutlet weak var middleLabel: UILabel!
    
    var mailArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        passwordtext.isSecureTextEntry = true
        verifyPasswordText.isSecureTextEntry = true
        
    }
    
    @IBAction func signupClicked(_ sender: Any) {
        let passwordRegPattern = "(?=.{8,})"
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let password = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        let mail = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        let name = NSEntityDescription.insertNewObject(forEntityName: "UserInfo", into: context)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if let mail = result.value(forKey: "email") as? String{
                    self.mailArray.append(mail)
                }
                
            }
        } catch {
            print("error")
        }
        
        if (mailArray.contains(mailtext.text!)) {
            let alert = UIAlertController(title: "Account Exists", message: "There is an account with this email address.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                UIAlertAction in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
            
        } else {
            if ((passwordtext.text?.range(of: passwordRegPattern, options: .regularExpression) != nil)&&(mailtext.text?.range(of: emailRegEx, options: .regularExpression) != nil)) {
                if (passwordtext.text == verifyPasswordText.text){
                    
                    let alert = UIAlertController(title: "Registration Successful", message: "You are redirected to the login page", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                        password.setValue(self.passwordtext.text, forKey: "password")
                        mail.setValue(self.mailtext.text, forKey: "email")
                        name.setValue(self.nametext.text, forKey: "name")
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                } else {
                    let alert = UIAlertController(title: "Password Error", message: "Passwords do not match", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                        UIAlertAction in
                    }
                    alert.addAction(okAction)
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Invalid Information", message: "Check E-Mail and Password again", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
