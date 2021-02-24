//
//  RegistrationController.swift
//  PutMeOn!
//
//  Created by Zach mills on 10/14/20.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    //    MARK: - Properties
    
    private let imagePicker = UIImagePickerController()
    private var profilePic: UIImage?
    
    private let addAviButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfileButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let image = #imageLiteral(resourceName: "message_unselected")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        
        
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_lock_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        
        
        return view
       
    }()
    
    private lazy var fullNameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: fullNameTextField)
        
        
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = #imageLiteral(resourceName: "ic_person_outline_white_2x")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
        
        
        return view
       
    }()
    
    private let emailTextField: UITextField = {
        
        let tf = Utilities().textFieldCustomization(withPlaceholder: "Email")
        
        
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        
        let tf = Utilities().textFieldCustomization(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        
        
        return tf
    }()
    
    private let fullNameTextField: UITextField = {
        
        let tf = Utilities().textFieldCustomization(withPlaceholder: "Full Name")
        
        
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        
        let tf = Utilities().textFieldCustomization(withPlaceholder: "Username")
        
        
        
        return tf
    }()
    
    
    
    
    
    
        
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have an account? ", "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let createAccountButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create Account", for: .normal)
        button.setTitleColor(.amColor, for: .normal)
        button.backgroundColor = .white
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    //    MARK: - Lifecycle

        override func viewDidLoad() {
            super.viewDidLoad()

            configureUI()
            
            
        }
    
    //    MARK: - Selectors
    
    @objc func handleSignUp() {
        guard let profilePic = profilePic else {
            print("DEBUG: Please select a profile image")
            return
        }
        
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = usernameTextField.text?.lowercased() else { return }
        
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profilePic: profilePic)
        
        AuthService.shared.registerUser(credentials: credentials) { (error, ref) in
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            
            guard let tab = window.rootViewController as?
                    MainTabBarController else { return }
            
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }
        
    }
    
    @objc func handleAddProfileButton() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
        
    //    MARK: - Helper Functions

    
    func configureUI() {
        view.backgroundColor = .amColor
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        view.addSubview(addAviButton)
        addAviButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        addAviButton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, usernameContainerView, fullNameContainerView, createAccountButton])
        
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        
        view.addSubview(stack)
        stack.anchor(top: addAviButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 33, paddingLeft: 27, paddingRight: 27)
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 40,  paddingRight: 40)
    }

}

// MARK: - UIImagePickerController Delegate

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profilePic = info[.editedImage] as? UIImage else { return }
        self.profilePic = profilePic
        
        addAviButton.layer.cornerRadius = 128 / 2
        addAviButton.layer.masksToBounds = true
        addAviButton.imageView?.contentMode = .scaleAspectFill
        addAviButton.imageView?.clipsToBounds = true
        addAviButton.layer.borderColor = UIColor.white.cgColor
        addAviButton.layer.borderWidth = 3
        
        self.addAviButton.setImage(profilePic.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
    
}
