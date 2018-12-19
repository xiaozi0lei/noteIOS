//
//  MyService.swift
//  noteIOS
//
//  Created by Sun GuoLei on 2018/12/18.
//  Copyright © 2018 Sun GuoLei. All rights reserved.
//

import Foundation
import Moya

enum MyService {
    case getList
    case showUser(id: Int)
    case createUser(firstName: String, lastName: String)
    case updateUser(id: Int, firstName: String, lastName: String)
    case showAccounts
}

// MARK: - TargetType Protocol Implementation
extension MyService: TargetType {
    // 服务器地址
    var baseURL: URL { return URL(string: "http://localhost:8080")! }
    
    // 方法路径映射
    var path: String {
        switch self {
        case .getList:
            return "/note/indexJson"
        case .showUser(let id), .updateUser(let id, _, _):
            return "/users/\(id)"
        case .createUser(_, _):
            return "/users"
        case .showAccounts:
            return "/accounts"
        }
    }
    
    
    
    // 请求方法，get 或者 post
    var method: Moya.Method {
        switch self {
        case .getList, .showUser, .showAccounts:
            return .get
        case .createUser, .updateUser:
            return .post
        }
    }
    
    //一个请求任务事件
    var task: Task {
        switch self {
        case .getList:
            return .requestParameters(parameters: ["pageNum": 1, "pageSize": 50], encoding: URLEncoding.queryString)
        case .showUser, .showAccounts: // Send no parameters
            return .requestPlain
        case let .updateUser(_, firstName, lastName):  // Always sends parameters in URL, regardless of which HTTP method is used
            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: URLEncoding.queryString)
        case let .createUser(firstName, lastName): // Always send parameters as JSON in request body
            return .requestParameters(parameters: ["first_name": firstName, "last_name": lastName], encoding: JSONEncoding.default)
        }
    }
    
    //编码转义
    var sampleData: Data {
        switch self {
        case .getList:
            return "Half measures are as bad as nothing at all.".utf8Encoded
        case .showUser(let id):
            return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".utf8Encoded
        case .createUser(let firstName, let lastName):
            return "{\"id\": 100, \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
        case .updateUser(let id, let firstName, let lastName):
            return "{\"id\": \(id), \"first_name\": \"\(firstName)\", \"last_name\": \"\(lastName)\"}".utf8Encoded
        case .showAccounts:
            // Provided you have a file named accounts.json in your bundle.
            guard let url = Bundle.main.url(forResource: "accounts", withExtension: "json"),
                let data = try? Data(contentsOf: url) else {
                    return Data()
            }
            return data
        }
    }
    var headers: [String: String]? {
        return ["Content-type": "application/json"]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    
    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
