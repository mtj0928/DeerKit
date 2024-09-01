public func withThrowingOrderedTaskGroup<ChildTaskResult: Sendable, GroupResult>(
    of childTaskResultType: ChildTaskResult.Type,
    returning returnType: GroupResult.Type = GroupResult.self,
    body: (inout ThrowingOrderedTaskGroup<ChildTaskResult, any Error>) async throws -> GroupResult
) async rethrows -> GroupResult {
    try await withThrowingTaskGroup(of: (TaskID, ChildTaskResult).self, returning: returnType) { group in
        var throwingOrderedTaskGroup = ThrowingOrderedTaskGroup<ChildTaskResult, any Error>(group)
        return try await body(&throwingOrderedTaskGroup)
    }
}

public struct ThrowingOrderedTaskGroup<ChildTaskResult, Failure> where ChildTaskResult : Sendable, Failure : Error {
    private var taskID = TaskID.create()
    private var internalGroup: ThrowingTaskGroup<(TaskID, ChildTaskResult), Failure>

    private var registeredTaskIDs: [TaskID] = []
    private var results: [TaskID: ChildTaskResult] = [:]

    fileprivate init(_ internalGroup: ThrowingTaskGroup<(TaskID, ChildTaskResult), Failure>) {
        self.internalGroup = internalGroup
    }

    public mutating func addTask(
        priority: TaskPriority? = nil,
        operation: @escaping @Sendable () async throws -> ChildTaskResult
    ) {
        let id = taskID
        registeredTaskIDs.append(id)
        internalGroup.addTask(priority: priority) {
            let result = try await operation()
            return (id, result)
        }
        self.taskID = taskID.next()
    }

    public mutating func waitForAll() async throws {
        try await internalGroup.waitForAll()
    }
}

extension ThrowingOrderedTaskGroup: AsyncSequence, AsyncIteratorProtocol where Failure: Error {

    public typealias Element = ChildTaskResult

    public func makeAsyncIterator() -> Self {
        self
    }

    public mutating func next() async throws -> ChildTaskResult? {
        while true {
            let targetID = registeredTaskIDs.first

            if let targetID,
               let result = results[targetID] {
                results.removeValue(forKey: targetID)
                registeredTaskIDs.removeFirst()
                return result
            }

            if let (id, element) = try await internalGroup.next() {
                // Store the result
                results[id] = element
            } else {
                // Reset
                registeredTaskIDs.removeAll()
                results.removeAll()
                return nil
            }
        }
    }
}

fileprivate struct TaskID: Hashable {
    private let rawValue: UInt64

    private init(rawValue: UInt64) {
        self.rawValue = rawValue
    }

    func next() -> TaskID {
        TaskID(rawValue: (rawValue + 1) % UInt64.max)
    }

    static func create() -> TaskID { TaskID(rawValue: 0) }
}
