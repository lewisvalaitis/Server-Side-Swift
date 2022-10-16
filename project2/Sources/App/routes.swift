import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    let polls = app.grouped("polls")
    
    polls.post("create") { req async throws -> CreatePollResponse in
        let jsonBody = try req.content.decode(Poll.JsonBody.self)
        let poll = Poll(jsonBody: jsonBody)
        try await poll.save(on: req.db)
        
        return CreatePollResponse(password: poll.password, poll: poll.jsonBody)
    }
    
    polls.post("delete") { req async throws -> Poll.JsonBody in
        
        let deletePollRequest = try req.content.decode(DeletePoll.self)
        
        guard let poll = try await Poll.find(deletePollRequest.id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        guard poll.password == deletePollRequest.password else {
            throw Abort(.forbidden)
        }
        try await poll.delete(on: req.db)
        
        return poll.jsonBody
    }
    
    polls.post("vote", ":id", ":option") { req async throws -> Poll.JsonBody in
        guard let id =  req.parameters.get("id", as: UUID.self),
              let option = req.parameters.get("option", as: Int.self) else {
            throw Abort(.badRequest)
        }
        
        let poll = try await Poll.find(id, on: req.db)
        
        guard let poll else {
            throw Abort(.notFound)
        }
        
        if option == 1 {
            poll.votes1 += 1
        } else {
            poll.votes2 += 1
        }
        
        try await poll.save(on: req.db)
        
        return poll.jsonBody
    }
    
    polls.get("list") { req async throws -> [Poll.JsonBody] in
        let polls = try await Poll.query(on: req.db).all()
        
        return polls.map(\.jsonBody)
    }
    
    polls.get(":id") { req async throws -> Poll.JsonBody in
        guard let id = req.parameters.get("id", as: UUID.self) else {
            throw Abort(.badRequest)
        }
        
        guard let poll = try await Poll.find(id, on: req.db) else {
            throw Abort(.notFound)
        }
        
        return poll.jsonBody
    }
}


extension Poll {
    convenience init(jsonBody: Poll.JsonBody) {
        self.init()
        
        id = jsonBody.id
        title = jsonBody.title
        option1 = jsonBody.option1
        option2 = jsonBody.option1
        votes1 = jsonBody.votes1
        votes2 = jsonBody.votes2
        password = String.random(length: 10)
    }
}
