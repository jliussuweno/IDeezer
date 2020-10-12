//
//  RegisterViewController.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit

class RegisterViewController: UIViewController {

    //MARK: - Props
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var user = User()
    var databaseManager = DatabaseManager()
    
    //MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseManager.initDB()
    }
    
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        user.email = emailTextField.text ?? ""
        user.password = passwordTextField.text ?? ""
        let userList = databaseManager.readDBValueRegister(inputData: user)
        
        if emailTextField.text == "" {
            showAlert(message: "Full Name harus diisi", segue: "stayHereSegue")
        } else if passwordTextField.text == "" {
            showAlert(message: "Email harus diisi", segue: "stayHereSegue")
        } else if userList.count == 0 {
            if databaseManager.saveDBValueUser(inputData: user) {
                showAlert(message: "Register berhasil", segue: "loginSegue")
            } else {
                showAlert(message: "Register gagal, silahkan ulangi", segue: "stayHereSegue")
            }
        } else if userList.count == 1 {
            showAlert(message: "Email sudah terdaftar, silahkan login", segue: "loginSegue")
        }
        
    }
    
    //MARK: - Custom Methods
    func showAlert(message: String, segue: String){
        let alert = UIAlertController(title: "Register", message: message, preferredStyle: .alert)
        if segue == "loginSegue" {
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler:{ action in self.performSegue(withIdentifier: segue, sender: nil) } ))
        } else {
            alert.addAction(UIAlertAction(title: "Kembali", style: .default, handler: nil))
        }
        self.present(alert, animated: true)
    }
    
    
}
