//
//  URL+extension.swift
//  DeerKit
//
//  Created by Junnosuke Matsumoto on 2021/02/11.
//

import Foundation

extension URL {

    var queryKeys: [String] {
        URLComponents(string: absoluteString)?.queryItems?.map { $0.name } ?? []
    }

    func queryValue(for key: String) -> String? {
        let queryItems = URLComponents(string: absoluteString)?.queryItems
        return queryItems?.filter { $0.name == key }.compactMap { $0.value }.first
    }
}
