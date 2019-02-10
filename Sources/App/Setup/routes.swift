import Vapor

public func routes(_ router: Router) throws {
    
    let gatewayController = GatewayController()
    try router.register(collection: gatewayController)
}
