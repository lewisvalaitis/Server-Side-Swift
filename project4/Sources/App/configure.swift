import Vapor
import Leaf
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))

    // set up database
    app.databases.use(.sqlite(.file("\(app.directory.workingDirectory)forums.sqlite")), as: .sqlite)
    
    app.migrations.add(CreateForums(), to: .sqlite)
    
    try await app.autoMigrate()
    
    app.views.use(.leaf)
    
    // register routes
    try routes(app)
}
