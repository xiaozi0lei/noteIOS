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
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "提示", message: "用户名密码错误", preferredStyle: .alert)
        let action = UIAlertAction(title: "确定", style: .destructive, handler: nil)
        alert.addAction(action)
        
        if let username = self.username.text {
            if let password = self.password.text {
                if username != "" && password != "" {
                    //                    if username == "" {
                    provider.request(.login(username: username, password: password)) { result in
                        // do something with result
                        switch result {
                        case let .success(result):
                            do {
                                try print("result.mapJSON() = \(result.mapJSON())")
                                let viewController = ViewController()
                                //        把视图压入导航视图
                                self.navigationController?.pushViewController(viewController, animated: true)
                            } catch {
                                print("MoyaError.jsonMapping(result) = \(MoyaError.jsonMapping(result))")
                                self.present(alert, animated: true, completion: nil)
                            }
                        case let .failure(error):
                            print(error)
                        }
                        print("result = \(result.description)")
                    }
                } else {
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}
