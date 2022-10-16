import Vapor

func routes(_ app: Application) throws {
    app.get { req async in
        "It works!"
    }

    app.get("articles", ":article") { req throws -> Article in
        let article = req.parameters.get("article", as: Article.self)
        
        guard let article else {
            throw Abort(.badRequest)
        }
        return article
    }
    
    try app.register(collection: AdminCollection())
}
