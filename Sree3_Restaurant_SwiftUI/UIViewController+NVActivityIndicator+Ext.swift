//
//  UIViewController+NVActivityIndicator+Ext.swift
//  Sree3_Resturant_IOS
//
//  Created by Maher on 9/26/21.
//

import Foundation
import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {

    func showActivityIndicator() {
        let color: UIColor = .gray
         startAnimating(nil, message: nil, messageFont: nil, type: .lineSpinFadeLoader, color: color , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .clear, textColor: nil, fadeInAnimation: nil)
     }

     func killActivityIndicator(){
         stopAnimating()
     }

}
