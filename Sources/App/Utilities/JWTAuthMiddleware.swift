import Vapor
import Authentication
import JWT

struct JWTAuthMiddleware: Middleware {
    
    func respond(to request: Request, chainingTo next: Responder) throws -> EventLoopFuture<Response> {
        guard let token = request.http.headers.bearerAuthorization else {
            throw Abort(.unauthorized)
        }
        let signer = JWTSigner.hs256(key: Data("kaas".utf8))
        do {
            // We only verify
            _ = try JWT<JWTAuthorizationPayload>(from: token.token, verifiedUsing: signer)
        } catch {
            throw Abort(.unauthorized)
        }
        return try next.respond(to: request)
    }
}
