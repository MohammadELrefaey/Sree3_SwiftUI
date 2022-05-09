//
//  APIRouter.swift
//  Sree3_iOS
//
//  Created by Maher on 9/14/21.
//

import Alamofire

enum APIRouter: URLRequestConvertible {
    
    case login(userName: String, password: String)
    case logout(token: String)
    case updatePlayerId(token: String, playerID: String)
    case getNewOrders(page: Int, token: String)
    case getAcceptedOrders(page: Int, token: String)
    case getLoggedOrders(page: Int, token: String)
    case approveOrder(token: String, orderID: Int)
    case cancelOrder(token: String, orderID: Int)
    case finishOrder(token: String, orderID: Int)
    case completeOrder(token: String, orderID: Int, runnerID: Int)
    case getOrderDetails(token: String, orderID: Int)
    case getItems(page: Int, token: String)
    case getSubItems(page: Int, token: String, itemID: Int)
    case changeItemStatus(token: String, staus: Int, itemID: Int)
    case changeSubItemStatus(token: String, staus: Int, itemID: Int)
    case changeRestaurantStatus(token: String, staus: Int, ID: Int)
    case checkPlaceStatus(token: String)
    case checkVersion
    case fastOrder(token: String, lat: String, long: String, placeName: String, districtId: Int, storeName: String, orderDetails: [String])
    case getDistricts(token: String)
    // MARK: - HTTPMethod
    private var method: HTTPMethod {
        switch self {
        case .login, .logout, .updatePlayerId, .getNewOrders, .getAcceptedOrders, .getLoggedOrders, .approveOrder, .cancelOrder, .finishOrder, .completeOrder, .changeItemStatus, .changeSubItemStatus, .changeRestaurantStatus, .fastOrder: return .post
        
        case .getOrderDetails, .getItems, .getSubItems, .checkPlaceStatus, .checkVersion, .getDistricts:  return .get

        }
    }
    
    // MARK: - Path
    private var path: String {
        switch self {
        case .login: return "login"
        case .logout: return "logout"
        case .updatePlayerId: return "update/player_id"
        case .getNewOrders: return "orders/pending"
        case .getAcceptedOrders: return "orders/accepted"
        case .getLoggedOrders: return "orders"
        case .approveOrder: return "approve/order"
        case .cancelOrder: return "cancel/order"
        case .finishOrder: return "finish/order"
        case .completeOrder: return "complete/order"
        case .getOrderDetails(let token, let orderID): return "order_detail?order_id=\(orderID)&token=\(token)"
        case .getItems(let page, let token): return "items?page=\(page)&token=\(token)"
        case .getSubItems(let page, let token, let itemID): return "sub_items/\(itemID)?page=\(page)&token=\(token)"
        case .changeItemStatus: return "items/change_status"
        case .changeSubItemStatus: return "sub_items/change_status"
        case .changeRestaurantStatus: return "change_status"
        case .checkPlaceStatus(let token): return "checkPlaceStatus?token=\(token)"
        case .checkVersion: return "ios/version"
        case .fastOrder: return "orders/anything"
        case .getDistricts(let token): return  "districts/100?token=\(token)"
        }
    }
        
    // MARK: - Parameters
    private var parameters: Parameters? {
        switch self {
        case .login(let userName, let password):
            let parameters = ["login_code": userName , "password": password]
            return parameters
            
            
        case .logout(let token):
            let parameters = ["token" : token]
            return parameters
            
            
        case .updatePlayerId(let token, let playerID):
            let parameters: [String:Any] = ["token" : token , "player_id" : playerID]
            return parameters
            
        
        case .getNewOrders(let page, let token):
            let parameters: [String:Any] = ["page" : page , "token" : token]
            return parameters
            
            
        case .getAcceptedOrders(let page, let token):
            let parameters: [String:Any] = ["page" : page , "token" : token]
            return parameters
            

        case .getLoggedOrders(let page, let token):
            let parameters: [String:Any] = ["page" : page , "token" : token]
            return parameters
            
            
        case .approveOrder(let token, let orderID):
            let parameters: [String:Any] = ["token" : token , "order_id" : orderID]
            return parameters
            
            
        case .cancelOrder(let token, let orderID):
            let parameters: [String:Any] = ["token" : token , "order_id" : orderID]
            return parameters
            

        case .finishOrder(let token, let orderID):
            let parameters: [String:Any] = ["token" : token , "order_id" : orderID]
            return parameters
            
            
        case .completeOrder(let token, let orderID, let runnerID):
            let parameters: [String:Any] = ["token" : token , "order_id" : orderID, "runner_id":runnerID]
            return parameters
            


        case .getOrderDetails: return nil
            

        case .getItems: return nil
            
            
        case .getSubItems: return nil
            
        case .checkPlaceStatus: return nil

        case .checkVersion: return nil
         
        case .changeItemStatus(let token, let status, let itemID):
        let parameters: [String:Any] = ["token" : token, "active" : status, "id" : itemID]
        return parameters
            
            
        case .changeSubItemStatus(let token, let status, let itemID):
        let parameters: [String:Any] = ["token" : token, "active" : status, "id" : itemID]
        return parameters
            

        case .changeRestaurantStatus(let token, let status, let ID):
        let parameters: [String:Any] = ["token" : token, "busy" : status, "id" : ID]
        return parameters


        case .fastOrder(let token, let lat, let long, let placeName, let districtId, let storeName, let orderDetails):
            let parameters: [String:Any] = ["token" : token, "pickup_lat" : lat, "pickup_lng" : long, "placePickName" : placeName, "district_id" : districtId, "store_name": storeName, "order_details": orderDetails]
            return parameters

        case .getDistricts: return nil
        }
    }
    
    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let main_api_url = Constants.LiveServer.baseURL + path
        let urlComponents = URLComponents(string: main_api_url)!
        let url = urlComponents.url!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        print("URLS REQUEST :\(urlRequest)")
        
        
        // Parameters
        if let parameters = parameters {
            do {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
            } catch {
                throw AFError.parameterEncodingFailed(reason: .jsonEncodingFailed(error: error))
            }
        }
        
        
        if  path == "login" || path == "logout" || path == "update/player_id" || path.contains("orders") || path.contains("order") || path == "change_status" || path == "sub_items/change_status" || path == "items/change_status" {
            return try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        print(urlRequest.description)
        
        
        return urlRequest as URLRequest
        
        
    }
}
