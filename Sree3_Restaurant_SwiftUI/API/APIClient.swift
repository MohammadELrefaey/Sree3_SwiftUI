//
//  APIClient.swift
//  Sree3_iOS
//
//  Created by Maher on 9/14/21.
//

import Foundation
import Alamofire
import SwiftyJSON

class APIClient {
    
    @discardableResult
    static func performSwiftyRequest(route:APIRouter,_ completion:@escaping (JSON)->Void,_ failure:@escaping (Error?)->Void) -> DataRequest {
        return AF
            .request(route)
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success :
                    
                    print("success")
                    guard let _ = response.value
                    else {
                        failure(response.error)
                        return
                    }
                    let json = JSON(response.value as Any)
                    
                    print("jsonn\(json)")
                    
                    if response.response?.statusCode == 400 {
                        
                    }
                    let statusCode = json["error"]["status_code"].intValue
                    if statusCode == 400 {
                        completion(json)
                    }
                    else{
                        completion(json)
                    }
                case .failure( _):
                    print("json error \(String(describing: response.error))")
                    print("staus \(String(describing: response.response?.statusCode))")
                    if response.response?.statusCode == 500 {
                        print(JSON(response.value as Any))
                        failure(nil)
                    } else {
                        failure(response.error)
                        ad.showSinglePopUp(message: "من فضلك تحقق من اتصالك بشبكة الانترنت", buttonTitle: "موافق")
                    }
                }
            })
    }
    
    
    //MARK:- Login
    static func login(userName:String,
                      password:String,
                      completionHandler:@escaping (LoginResponse?,ResponseError?)->Void,
                      completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .login(userName: userName, password: password), { (jsonData) in
            
            do{
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    if jsonData["error"]["status_code"].intValue == 400 {
                        let error = ResponseError.init(jsonDict)
                        completionHandler(nil,error)
                    } else {
                        let userData = LoginResponse.init(fromDictionary: jsonDict)
                        completionHandler(userData,nil)
                    }
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    

    //MARK:- Logout
    static func logout(token:String,
                       completionHandler:@escaping (LogoutResponse?)->Void,
                       completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .logout(token: token), { (jsonData) in
            
            do{
                print(jsonData)
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = LogoutResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    
    //MARK:- Updtate Player Id
    static func updatePlayerId(token:String, playerId: String,
                               completionHandler:@escaping (MessageResponse?)->Void,
                               completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .updatePlayerId(token: token, playerID: playerId), { (jsonData) in
            
            do{
                print(jsonData)
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = MessageResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Get Orders
    static func getOrders(type: SegmentType ,page: Int, token:String,
                             completionHandler:@escaping (OrdersRsponse?)->Void,
                             completionFaliure:@escaping (_ error:Error?)->Void){
        let route: APIRouter!
        switch type {
        case .new:
            route = .getNewOrders(page: page, token: token)
            
        case .accepted:
            route = .getAcceptedOrders(page: page, token: token)
            
        case .logged:
            route = .getLoggedOrders(page: page, token: token)
        }
        
        
        performSwiftyRequest(route: route, { (jsonData) in
            
            do{
                print(jsonData)
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = OrdersRsponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    

    
    //MARK:- Approve Order
    static func approveOrder(orderID: Int, token:String,
                             completionHandler:@escaping (HandleOrderResponse?)->Void,
                             completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .approveOrder(token: token, orderID: orderID), { (jsonData) in
            
            do{
                print(jsonData)
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = HandleOrderResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Cancel Order
    static func cancelOrder(orderID: Int, token:String,
                            completionHandler:@escaping (MessageResponse?)->Void,
                            completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .cancelOrder(token: token, orderID: orderID), { (jsonData) in
            
            do{
                print(jsonData)
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = MessageResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Finish Order
    static func finishOrder(orderID: Int, token:String,
                            completionHandler:@escaping (MessageResponse?)->Void,
                            completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .finishOrder(token: token, orderID: orderID), { (jsonData) in
            
            do{
                print(jsonData)
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = MessageResponse.init(jsonDict)
                    print("status\(response)")
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Complete Order
    static func completeOrder(orderID: Int, token:String, runnerId: Int,
                              completionHandler:@escaping (MessageResponse?)->Void,
                              completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .completeOrder(token: token, orderID: orderID, runnerID: runnerId), { (jsonData) in
            
            do{
                print(jsonData)
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = MessageResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Get Order Details
    static func getOrderDetails(orderID: Int, token:String,
                                completionHandler:@escaping (OrderDetailsResponse?)->Void,
                                completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .getOrderDetails(token: token, orderID: orderID), { (jsonData) in
            
            do{
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = OrderDetailsResponse.init(jsonDict)
                    print("response \(response)")
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Get Items
    static func getItems(page: Int, token:String,
                         completionHandler:@escaping (ItemsResponse?)->Void,
                         completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .getItems(page: page, token: token), { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = ItemsResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Get Sub Items
    static func getSubItems(page: Int, token: String, itemID: Int,
                            completionHandler:@escaping (SubItemsResponse?)->Void,
                            completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .getSubItems(page: page, token: token, itemID: itemID), { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = SubItemsResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Change Item Status
    static func changeItemStatus(token: String, status: Int, itemID: Int,
                                 completionHandler:@escaping (StatusResponse?)->Void,
                                 completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .changeItemStatus(token: token, staus: status, itemID: itemID), { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = StatusResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Change Sub Items Status
    static func changeSubItemStatus(token: String, status: Int, itemID: Int,
                                    completionHandler:@escaping (StatusResponse?)->Void,
                                    completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .changeSubItemStatus(token: token, staus: status, itemID: itemID), { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = StatusResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Change Restaurant Status
    static func changeRestaurantStatus(token: String, status: Int, id: Int,
                                       completionHandler:@escaping (StatusResponse?)->Void,
                                       completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .changeRestaurantStatus(token: token, staus: status, ID: id), { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = StatusResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    //MARK:- Check Restaurant Status
    static func checkRestaurantStatus(token: String,
                                      completionHandler:@escaping (StatusResponse?)->Void,
                                      completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .checkPlaceStatus(token: token), { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = StatusResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    
    //MARK:- Check Version
    static func checkVersion(
        completionHandler:@escaping (CheckVersionResponse?)->Void,
        completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .checkVersion, { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = CheckVersionResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }
    
    
    //MARK:- Fast Order
    static func fastOrder(token: String, lat: String, long: String, placeName: String, districtId: Int, storeName: String, orderDetails: [String],
                          completionHandler:@escaping (HandleOrderResponse)->Void,
        completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .fastOrder(token: token, lat: lat, long: long, placeName: placeName, districtId: districtId, storeName: storeName, orderDetails: orderDetails), { (jsonData) in
            
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = HandleOrderResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }

    //MARK:- Get Districts
    static func getDistricts(token: String, completionHandler:@escaping (DistrictsResponse)->Void,
        completionFaliure:@escaping (_ error:Error?)->Void){
        performSwiftyRequest(route: .getDistricts(token: token), { (jsonData) in
            do{
                print("json data \(jsonData)")
                if let jsonDict = try JSONSerialization.jsonObject(with: JSON(jsonData).rawData(), options: []) as? [String:Any]{
                    let response = DistrictsResponse.init(jsonDict)
                    completionHandler(response)
                }
            }
            catch{
                completionFaliure(error)
            }
        }) { (error) in
            completionFaliure(error)
        }
    }

}
