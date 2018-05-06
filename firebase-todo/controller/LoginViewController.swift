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

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

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
        submitBtn.cornerRadius = 20
        submitBtn.addTarget(self, action: #selector(loginOrRegister(_:)), for: .touchUpInside)
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
                    self.submitBtn.stopAnimation(animationStyle: .shake, completion: nil)
                    return
                }
                
                self.submitBtn.stopAnimation(animationStyle: StopAnimationStyle.expand, completion: {
                        let taskListView = self.storyboard?.instantiateViewController(withIdentifier: "taskListView") as! TaskTableViewController
                    
                    self.present(taskListView, animated: true, completion: nil)
                })

                self.dismiss(animated: true, completion: nil)
            }
        } else {
            print("nice try nerd")
            self.submitBtn.stopAnimation(animationStyle: .shake, completion: nil)
        }
    }
    
    func register () {
        if nameField?.text != nil, emailField?.text != nil, passwordField?.text != nil, confirmPasswordField.text != nil {
            let name = nameField!.text!,
                email = emailField!.text!,
                password = passwordField!.text!,
                confirmPassword = confirmPasswordField!.text!
            
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
                if err != nil {
                    print(err.debugDescription)
                    self.submitBtn.stopAnimation(animationStyle: .shake, completion: nil)
                    return
                }
                
                guard let uid = user?.uid else {
                    print("Authentication failed")
                    self.submitBtn.stopAnimation(animationStyle: .shake, completion: nil);
                    return
                }
                
                let values = ["name": name, "email": email]
                self.login();
            }
        }
    }
    
    // MARK: - Events
    @IBAction func switchToLoginView() {
        showLoginView = true
        
        confirmPasswordField.alpha = 0
        nameField.alpha = 0
        
        submitBtn.setTitle("Login", for: .normal)
        submitBtn.backgroundColor = UIColor(hexString: "#55efc4")
    }
    @IBAction func switchToRegisterView(_ sender: Any) {
        showLoginView = false
        
        confirmPasswordField.alpha = 1
        nameField.alpha = 1
        
        submitBtn.setTitle("Register", for: .normal)
        submitBtn.backgroundColor = UIColor(hexString: "#81ecec")
    }
    
    @IBAction func loginOrRegister (_ button: TransitionButton) {
        submitBtn.startAnimation()
        if (showLoginView) {
            login();
        } else {
            register();
        }
        
    }
}
