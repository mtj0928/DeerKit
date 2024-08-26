import Foundation

extension URL {

    public var queryKeys: [String] {
        URLComponents(string: absoluteString)?.queryItems?.map { $0.name } ?? []
    }

    public func queryValue(for key: String) -> String? {
        let queryItems = URLComponents(string: absoluteString)?.queryItems
        return queryItems?.filter { $0.name == key }.compactMap { $0.value }.first
    }
}
