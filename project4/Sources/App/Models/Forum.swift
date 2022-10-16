//
//  File.swift
//  
//
//  Created by Lewis Valaitis on 03/10/2022.
//

import Foundation
import Fluent

class Forum: Model {
    
    static var schema = "forums"
    
    @ID(custom: "id", generatedBy: .user)
    var id: Int?
    
    @Field(key: "name")
    var name: String
    
    required init() {}
    
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}


struct CreateForums: AsyncMigration {
    func revert(on database: FluentKit.Database) async throws {
        do {
            try await database.schema(Forum.schema)
                .id()
                .field("name", .string, .required)
                .create()
        } catch {
            print("Error occured during shema creation:", error)
        }
    }
    
    func prepare(on database: FluentKit.Database) async throws {
//        try await database.schema(Forum.schema).delete()
    }
}
