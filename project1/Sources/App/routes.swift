import Vapor

func routes(_ app: Application) throws {
    let bios = [
        "kirk": "My name is James Kirk and I love snakes.",
        "picard": "My name is Jean-Luc Picard and I'm mad for fish.",
        "sisko": "My name is Benjamin Sisko and I'm all about the budgies.",
        "janeway": "My name is Kathryn Janeway and I want to hug every hamster.",
        "archer": "My name is Jonathan Archer and beagles are my thing."
    ]
    
    app.get { req async throws -> View in
        let context = [String: String]()
        return try await req.view.render("home", context)
    }
    
    app.get("staff") { req async throws -> View in
        let context = ["allNames": bios.keys.sorted()]
        return try await req.view.render("allStaff", context)
    }

    app.get("staff", ":name") { req async throws -> View in
        
        struct StaffView: Codable {
            var name: String?
            var bio: String?
            var allNames: [String]
        }
        
        let context: StaffView
        let allNames = bios.keys.sorted()
        
        if let name = req.parameters.get("name"),
           let bio = bios[name] {
            context = StaffView(name: name, bio: bio, allNames: allNames)
        } else {
            context = StaffView(allNames: allNames)
        }
        
        return try await req.view.render("staff", context)
    }
    
    app.get("contact") { req async throws -> View in
        let context = [String: String]()
        return try await req.view.render("contact", context)
    }
}
