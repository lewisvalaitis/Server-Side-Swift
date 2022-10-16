import Vapor

func routes(_ app: Application) throws {
    app.get { req async throws -> View in
        struct HomeContext: Codable {
            var username: String?
            var forums: [Forum]
        }
        
        let forums = try await Forum.query(on: req.db).all()
        
        let context = HomeContext(username: "testing", forums: forums)
        print(context)
        
        return try await req.view.render("home", context)
    }

    app.get("setup") { req async throws -> String in
        let item1 = Forum(id: 1, name: "Taylor's Songs")
        let item2 = Forum(id: 2, name: "Taylor's Albums")
        let item3 = Forum(id: 3, name: "Taylor's Concerts")
        
        try await item1.create(on: req.db)
        try await item2.create(on: req.db)
        try await item3.create(on: req.db)
        
        return "Ok"
    }
}


func getUsername(_ req: Request) -> String? {
   return "Testing"
}
