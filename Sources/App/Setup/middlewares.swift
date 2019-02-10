import Vapor

public func middlewares(config: inout MiddlewareConfig) throws {
    config.use(ErrorMiddleware.self)
}
