//
//  LoginViewController.swift
//  vkapp
//
//  Created by George Kazhuro on 21.10.17.
//  Copyright © 2017 George Kazhuro. All rights reserved.
//

import UIKit
import VK_ios_sdk

class LoginViewController: UIViewController {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    let scope = ["VK_PER_GROUPS"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let instance = VKSdk.initialize(withAppId: "6229337")
        instance?.register(self)
        instance?.uiDelegate = self
        
        loginButton.clipsToBounds = true
        loginButton.layer.cornerRadius = 6
        
        logoImageView.image = logoImageView.image!.withRenderingMode(.alwaysTemplate)
        logoImageView.tintColor = UIColor.white
    }
    
    @IBAction func loginBtnPressed(sender: UIButton) {
        VKSdk.wakeUpSession(scope) { (state, error) in
            if (state == VKAuthorizationState.authorized) {
                print("success")
            } else {
                DispatchQueue.main.async {
                    VKSdk.authorize(self.scope)
                }
            }
        }
    }
}

extension LoginViewController: VKSdkUIDelegate, VKSdkDelegate {
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        present(controller, animated: true, completion: nil)
    }
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if (result.token) != nil {
            print("auth")
        } else if (result.error) != nil {
            // Пользователь отменил авторизацию или произошла ошибка
        }
    }
    
    func vkSdkAuthorizationStateUpdated(with result: VKAuthorizationResult!) {
        if result.state == .authorized {
            DispatchQueue.main.async {
                let mainNavigationController = self.storyboard?.instantiateViewController(withIdentifier: "MainNavigationController") as! UINavigationController
                self.present(mainNavigationController, animated: false, completion: nil)
            }
            
        }
    }
    
    func vkSdkUserAuthorizationFailed() -> Void {
        
    }
    
    func vkSdkAccessTokenUpdated(newToken:VKAccessToken?, oldToken:VKAccessToken?) -> Void {
        
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError:VKError?) -> Void {
        
    }
}
