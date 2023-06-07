//
//  ViewController.swift
//  EventsAppUIKit
//
//  Created by Виталий on 06.06.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var mailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    var mailArray = [String]()
    var passwordArray = [String]()
    var nameArray = [String]()
    var userName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
        passwordText.isSecureTextEntry = true
    }

    @IBAction func signinClicked(_ sender: Any) {
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appdelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "UserInfo")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject]{
                if let mail = result.value(forKey: "email") as? String{
                    self.mailArray.append(mail)
                }
                if let password = result.value(forKey: "password") as? String{
                    self.passwordArray.append(password)
                }
                if let name = result.value(forKey: "name") as? String{
                    self.nameArray.append(name)
                }
            }
        } catch {
            print("error")
        }
        
        if (mailArray.contains(mailText.text!)){
            let mailIndex = mailArray.firstIndex(where: {$0 == mailText.text})
            userName = nameArray[mailIndex!]
            if passwordArray[mailIndex!] == passwordText.text {
                performSegue(withIdentifier: "toMainPageVC", sender: nil)
            }
        } else {
            let alert = UIAlertController(title: "Not Found", message: "No account found for this e-mail address", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "toMainPageVC") {
            let vc = segue.destination as! TableViewController
            vc.name = userName
        }
    }

    
    @IBAction func signUpClicked(_ sender: Any) {
        performSegue(withIdentifier: "toSignupVC", sender: nil)
    }
    
    
}


//MARK: extensions

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
