import Vapor
import Authentication

struct GatewayController: RouteCollection {
    
    func boot(router: Router) throws {
        
        router.post("users", use: handle)
        
        let authMiddleware = JWTAuthMiddleware()
        let authRouter = router.grouped(authMiddleware)
        authRouter.get(PathComponent.anything, use: handle)
        authRouter.post(PathComponent.anything, use: handle)
        authRouter.delete(PathComponent.anything, use: handle)
        authRouter.put(PathComponent.anything, use: handle)
        authRouter.patch(PathComponent.anything, use: handle)
    }
}

private extension GatewayController {
    
    func handle(_ req: Request) throws -> Future<Response> {
        if req.http.urlString.hasPrefix("/users") {
            guard let usersHost = Environment.get("USERS_HOST") else { throw Abort(.badRequest) }
            return try handle(req, host: usersHost)
        }
        throw Abort(.badRequest)
    }
    
    func handle(_ req: Request, host: String) throws -> Future<Response> {
        let client = try req.make(Client.self)
        guard let url = URL(string: host + req.http.urlString) else {
            throw Abort(.internalServerError)
        }
        req.http.url = url
        req.http.headers.replaceOrAdd(name: "host", value: host)
        return client.send(req)
    }
}
