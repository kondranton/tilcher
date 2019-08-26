struct APIError: Codable {
    let code: String
    let field: String
    let message: String
}

extension APIError: Error {
    var localizedDescription: String {
        return message
    }
}
