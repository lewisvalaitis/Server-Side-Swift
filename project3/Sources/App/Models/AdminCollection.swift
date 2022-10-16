//
//  File.swift
//  
//
//  Created by Lewis Valaitis on 03/10/2022.
//

import Foundation
import Vapor

final class AdminCollection: RouteCollection {
    func boot(routes: Vapor.RoutesBuilder) throws {
        let article = routes.grouped("article", ":num")
        
        article.get("read") { req -> String in
            guard let num = req.parameters.get("num", as: Int.self) else {
                throw Abort(.badRequest)
            }
            
            return "Reading artical \(num)"
        }
        article.get("edit") { req -> String in
            guard let num = req.parameters.get("num", as: Int.self) else {
                throw Abort(.badRequest)
            }
            
            return "Editing artical \(num)"
        }
    }
}
