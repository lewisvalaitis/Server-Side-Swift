//
//  File.swift
//  
//
//  Created by Lewis Valaitis on 29/09/2022.
//

import Foundation
import Vapor

struct CreatePollResponse: Content {
    var password: String
    var poll: Poll.JsonBody
}
