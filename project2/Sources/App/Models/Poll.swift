//
//  File.swift
//  project2
//
//  Created by Lewis Valaitis on 28/09/2022.
//

import Foundation
import Vapor
import Fluent
import FluentSQLiteDriver

final class Poll: Model {
    static var schema = "polls"
    
    @ID(key: .id)
    var id: UUID?
    
    @Field(key: "title")
    var title: String
    
    @Field(key: "option1")
    var option1: String
    
    @Field(key: "option2")
    var option2: String
    
    @Field(key: "votes1")
    var votes1: Int
    
    @Field(key: "votes2")
    var votes2: Int
    
    @Field(key: "password")
    var password: String
    
    var jsonBody: JsonBody {
        return JsonBody(id: id, title: title, option1: option1, option2: option2, votes1: votes1, votes2: votes2)
    }
    
    init() {}
    
    init(id: UUID? = nil, title: String, option1: String, option2: String, votes1: Int, votes2: Int) {
        self.id = id
        self.title = title
        self.option1 = option1
        self.option2 = option2
        self.votes1 = votes1
        self.votes2 = votes2
        self.password = String.random(length: 10)
    }
    
    struct JsonBody: Content {
        var id: UUID?
        var title: String
        var option1: String
        var option2: String
        var votes1: Int
        var votes2: Int
    }
}

struct CreatePolls: AsyncMigration {
    func revert(on database: FluentKit.Database) async throws {
        do {
            try await database.schema("polls")
                .id()
                .field("title", .string, .required)
                .field("option1", .string, .required)
                .field("option2", .string, .required)
                .field("votes1", .int, .required)
                .field("votes2", .int, .required)
                .field("password", .string)
                .create()
        } catch {
            print("Error occured during shema creation:", error)
        }
    }
    
    func prepare(on database: FluentKit.Database) async throws {
//        try await database.schema("polls").delete()
    }
}

extension String {
    static func random(length: Int = 20) -> String {
        let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString: String = ""

        for _ in 0..<length {
            let randomValue = arc4random_uniform(UInt32(base.count))
            randomString += "\(base[base.index(base.startIndex, offsetBy: Int(randomValue))])"
        }
        return randomString
    }
}
