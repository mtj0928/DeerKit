extension Sequence where Element: Sendable {
    public func asyncMap<T: Sendable>(
        numberOfTasks: Int = .max,
        converter: @Sendable @escaping (Element) async throws -> T
    ) async rethrows -> [T] {
        try await withThrowingOrderedTaskGroup(of: T.self) { group in
            var values: [T] = []
            for (index, element) in self.enumerated() {
                if index >= numberOfTasks {
                    if let value = try await group.next() {
                        values.append(value)
                    }
                }
                group.addTask {
                    try await converter(element)
                }
            }

            for try await value in group {
                values.append(value)
            }
            return values
        }
    }

    public func asyncCompactMap<T: Sendable>(
        numberOfTasks: Int = .max,
        converter: @Sendable @escaping (Element) async throws -> T?
    ) async rethrows -> [T] {
        try await withThrowingOrderedTaskGroup(of: T?.self) { group in
            var values: [T] = []
            for (index, element) in self.enumerated() {
                if index >= numberOfTasks {
                    if let optionalValue = try await group.next(),
                       let value = optionalValue {
                        values.append(value)
                    }
                }
                group.addTask {
                    try await converter(element)
                }
            }

            for try await optionalValue in group {
                if let value = optionalValue {
                    values.append(value)
                }
            }
            return values
        }
    }

    public func asyncFilter(
        numberOfTasks: Int = .max,
        where predicate: @Sendable @escaping (Element) async throws -> Bool
    ) async rethrows -> [Element] {
        try await withThrowingOrderedTaskGroup(of: Element?.self) { group in
            var values: [Element] = []
            for (index, element) in self.enumerated() {
                if index >= numberOfTasks {
                    if let value = try await group.next() as? Element {
                        values.append(value)
                    }
                }
                group.addTask {
                    if try await predicate(element) {
                        return element
                    } else {
                        return nil
                    }
                }
            }

            for try await value in group {
                if let value {
                    values.append(value)
                }
            }
            return values
        }
    }
}
