import Vapor

struct UserAPI {
    let client: Client
    let baseURL: String

    struct Error: Debuggable {
        static let typeIdentifier = "UserAPIError"
        let identifier: String
        let reason: String

        init(_ identifier: String, _ reason: String) {
            self.identifier = identifier
            self.reason = reason
        }
    }

    init(client: Client, baseURL: String) {
        self.client = client
        self.baseURL = baseURL
    }

    public struct Posts: Content {
        public struct Comments: Content {
            var text: String
        }

        var title: String
        var text: String
        var comments: [Comments]
    }

    func posts(token: String) -> Future<[Posts]> {
        return client.get("\(baseURL)/1") { req in
            req.http.headers.bearerAuthorization = BearerAuthorization(token: token)
        }.convert4xx().flatMap { res in
            return try res.content.decode([Posts].self)
        }.catchMap { err in
            throw Error("posts", "Could not reach posts: \(err)")
        }
    }
}

struct HTTPClientError: Debuggable {
    var identifier: String {
        return res.status.code.description
    }

    var reason: String {
        return res.body.description
    }

    let res: HTTPResponse
}

extension Future where T == Response {
    func convert4xx() -> Future<Response> {
        return map { res in
            switch res.http.status.code {
            case 400...:
                throw HTTPClientError(res: res.http)
            default:
                return res
            }
        }
    }
}
