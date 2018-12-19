//
//  ViewController.swift
//  noteIOS
//
//  Created by Sun GuoLei on 2018/12/17.
//  Copyright © 2018 Sun GuoLei. All rights reserved.
//

import UIKit
import Moya
import SwiftyJSON

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    let provider = MoyaProvider<MyService>()
    var dataSource1 = [JSON]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let tableView = UITableView(frame: view.bounds, style: .grouped)
        tableView.backgroundColor = UIColor.white;
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        provider.request(.getList) { result in
            // do something with result
            switch result {
            case let .success(result):
                do {
                    try print("result.mapJSON() = \(result.mapJSON())")
                    let json = try JSON(data: result.data)
                    self.dataSource1 = json["data"]["list"].arrayValue
                    tableView.reloadData()

                } catch {
                    print(result.data)
                    print("MoyaError.jsonMapping(result) = \(MoyaError.jsonMapping(result))")
                }
            case let .failure(error):
                print(error)
            }
            print("result = \(result.description)")
        }
    }
    
    //MARK: UITableViewDataSource
    // cell的个数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource1.count
    }
    // UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellid = "testCellID"
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell==nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        
        let json: JSON = self.dataSource1[indexPath.row]
        print(json)
        cell?.textLabel?.text = json["title"].string
        //        cell?.detailTextLabel?.text = json["createTime"].string
        cell?.imageView?.image = UIImage(named:"Expense_success")
        return cell!
    }
    
    //MARK: UITableViewDelegate
    // 设置cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44.0
    }
    // 选中cell后执行此方法
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}
