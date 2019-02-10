import JWT

struct JWTAuthorizationPayload: JWTPayload {
    
    var exp: ExpirationClaim
    var sub: SubjectClaim
    var iss: IssuerClaim
    
    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
