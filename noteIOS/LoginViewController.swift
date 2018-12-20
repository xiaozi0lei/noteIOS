//
//  LoginViewController.swift
//  noteIOS
//
//  Created by Sun GuoLei on 2018/12/20.
//  Copyright © 2018 Sun GuoLei. All rights reserved.
//

import Foundation
import UIKit
import Moya
import SwiftyJSON


class LoginViewController: UIViewController {
    //    self.view.window?.rootViewController = ViewController()
    let provider = MoyaProvider<MyService>()
    
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        if var username = self.username.text {
            if var password = self.password.text {
                username = "sunguolei"
                password = "12345678"
                provider.request(.login(username: username, password: password)) { result in
                    // do something with result
                    switch result {
                    case let .success(result):
                        do {
                            try print("result.mapJSON() = \(result.mapJSON())")
//                            let json = try JSON(data: result.data)
                            self.view.window?.rootViewController = ViewController()
                        } catch {
                            print(result.data)
                            print("MoyaError.jsonMapping(result) = \(MoyaError.jsonMapping(result))")
                        }
                    case let .failure(error):
                        print(error)
                    }
                    print("result = \(result.description)")
                }
            } else {
                print("password is nil")
            }
        } else {
            print("username is nil")
        }
    }
}
