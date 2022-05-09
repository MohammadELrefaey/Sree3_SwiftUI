//
//  APIClient_Extension.swift
//  Sree3_iOS
//
//  Created by Maher on 9/14/21.
//

import Foundation
import SwiftyJSON

extension APIClient {
    
    // MARK: - Get Error
    static func getError(json:JSON) -> String {
        if   json["error"].count >= 1   {
            let error = json["error"][0].stringValue
            return error
        }else if let err = json["error"].string {
            
            return err
            
        } else {
            return json["message"].string ?? "Network Connection Error"
        }
    }
    
}
