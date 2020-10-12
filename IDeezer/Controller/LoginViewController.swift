//
//  ViewController.swift
//  IDeezer
//
//  Created by Jlius Suweno on 12/10/20.
//

import UIKit

var userActive = User()

class LoginViewController: UIViewController {
    
    //MARK: - Props
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var dbManager = DatabaseManager()
    
    //MARK: - Default Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        dbManager.initDB()
        dbManager.createTableUser()
        setupGesture()
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        emailTextField.setIcon(UIImage(named: "email")!)
        passwordTextField.setIcon(UIImage(named: "password")!)
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        userActive.email = emailTextField.text!
        userActive.password = passwordTextField.text!
        
        let userList = dbManager.readDBValueLogin(inputData: userActive)
        if userList.count == 0 {
            alertShow(message: "Akun tidak ditemukan")
        } else {
            self.performSegue(withIdentifier: "homeSegue", sender: self)
        }
    }
    
    //MARK: - Custom Methods
    func alertShow(message: String){
        let alert = UIAlertController(title: "Login", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    func setupGesture(){
        var tap : UITapGestureRecognizer
        tap = UITapGestureRecognizer(target: self, action: #selector(click))
        registerLabel.addGestureRecognizer(tap)
        registerLabel.isUserInteractionEnabled = true
    }
    
    @objc func click(){
        self.performSegue(withIdentifier: "registerSegue", sender: nil)
    }
    
}

//MARK: - UITextField
extension UITextField {
    func setIcon(_ image: UIImage) {
        let iconView = UIImageView(frame:
                                    CGRect(x: 10, y: 5, width: 20, height: 20))
        iconView.image = image
        let iconContainerView: UIView = UIView(frame:
                                                CGRect(x: 20, y: 0, width: 30, height: 30))
        iconContainerView.addSubview(iconView)
        leftView = iconContainerView
        leftViewMode = .always
    }
}

