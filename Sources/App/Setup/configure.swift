import Vapor

public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)
    
    /// Register middlewares
    var middlewaresConfig = MiddlewareConfig()
    try middlewares(config: &middlewaresConfig)
    services.register(middlewaresConfig)
}
