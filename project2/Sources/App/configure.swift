import Vapor
import Fluent
import FluentSQLiteDriver

// configures your application
public func configure(_ app: Application) async throws {
    // uncomment to serve files from /Public folder
    // app.middleware.use(FileMiddleware(publicDirectory: app.directory.publicDirectory))
    
//    app.logger.logLevel = .debug

        
    // set up database
    app.databases.use(.sqlite(.file("\(app.directory.workingDirectory)polls.sqlite")), as: .sqlite)
    
    app.migrations.add(CreatePolls(), to: .sqlite)
    
    try await app.autoMigrate()
    
    // register routes
    try routes(app)
}
