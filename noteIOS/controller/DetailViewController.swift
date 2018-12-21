//
//  DetailViewController.swift
//  noteIOS
//
//  Created by Sun GuoLei on 2018/12/21.
//  Copyright © 2018 Sun GuoLei. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class DetailViewController: UIViewController {
    let provider = MoyaProvider<MyService>()
    var noteId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(DetailViewController.actionBack))
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        let scrollView = UIScrollView(frame: view.bounds)
        scrollView.backgroundColor = UIColor.white
        let label = UILabel(frame: view.bounds)
        scrollView.addSubview(label)
        view.addSubview(scrollView)
        
        provider.request(.view(id: self.noteId)) { result in
            // do something with result
            switch result {
            case let .success(result):
                do {
                    let json = try JSON(data: result.data)
                    //设置Label文字显示的行数
                    label.numberOfLines = 0;
                    label.text = json["data"].string
                    label.sizeToFit()
                } catch {
                    print("MoyaError.jsonMapping(result) = \(MoyaError.jsonMapping(result))")
                }
            case let .failure(error):
                print(error)
            }
        }
    }
    
    @objc func actionBack(){
        self.navigationController?.popViewController(animated: true);
    }
}
