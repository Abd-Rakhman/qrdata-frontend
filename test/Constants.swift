//
//  Constants.swift
//  test
//
//  Created by Rakhman on 16.05.2022.
//

import UIKit

enum Constants {
    enum Colors {
        static var ObjectBackgroundColor: UIColor? {
            UIColor(named: "ObjectBackgroundColor")
        }
        
        static var ObjectBorderColor: CGColor? {
            UIColor(named: "ObjectBorderColor")?.cgColor
        }
    }
    
    static let dateFormatter: DateFormatter = {
        let dtf = DateFormatter()
        dtf.dateFormat = "dd/MM/YYYY"
        return dtf
    }()
}
