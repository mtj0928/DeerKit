import XCTest
import DeerSwift

final class ThrowingOrderedTaskGroupTests: XCTestCase {
    func testThrowingOrderedTaskGroup() async throws {
        let results = try await withThrowingOrderedTaskGroup(of: Int.self) { group in
            (0..<10).forEach { number in
                group.addTask {
                    await Task.yield()
                    return number
                }
            }
            var results: [Int] = []
            for try await number in group {
                results.append(number)
            }
            return results
        }
        XCTAssertEqual(results, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9])
    }
}
