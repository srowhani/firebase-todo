//
//  LoginViewController.swift
//  firebase-todo
//
//  Created by admin on 2018-05-05.
//  Copyright © 2018 admin. All rights reserved.
//
import TransitionButton
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    var showLoginView: Bool = true
    @IBOutlet weak var submitBtn: TransitionButton!
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(submitBtn)
        switchToLoginView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Functions
    func login () {
        if emailField?.text != nil, passwordField?.text != nil {
            Auth.auth().signIn(withEmail: emailField!.text!, password: passwordField!.text!) { (user, err) in
                if err != nil {
                    print(err.debugDescription)
                    return
                }
                
                self.dismiss(animated: true, completion: nil)
            }
        } else {
        
        }
    }
    
    // MARK: - Events
    @IBAction func switchToLoginView() {
        showLoginView = true
        
        confirmPasswordField.alpha = 0
        nameField.alpha = 0
        
        submitBtn.setTitle("Login", for: .normal)
        submitBtn.backgroundColor = .green
        submitBtn.cornerRadius = 20
        submitBtn.addTarget(self, action: #selector(loginOrRegister(_:)), for: .touchUpInside)
    }
    
    @IBAction func loginOrRegister (_ button: TransitionButton) {
        submitBtn.startAnimation()
        if (showLoginView) {
            login();
        }
        
    }
}
