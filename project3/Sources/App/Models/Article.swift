//
//  File.swift
//  
//
//  Created by Lewis Valaitis on 30/09/2022.
//

import Foundation
import Vapor
import Fluent

struct Article: Content, LosslessStringConvertible {
    
    var id: Int
    var title: String
    
    var description: String {
        title
    }
    
    init?(_ id: String) {
        if let intID = Int(id) {
            self.id = intID
            self.title = "Custom parameters rock"
        } else {
            return nil
        }
    }
}
