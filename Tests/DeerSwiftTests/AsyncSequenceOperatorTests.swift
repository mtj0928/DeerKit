import XCTest
import DeerSwift

final class AsyncSequenceOperatorTests: XCTestCase {
    func testAsyncMap() async throws {
        let array = [0, 1, 2, 3, 4, 5]
        let result = await array.asyncMap { number in
            await Task.yield()
            return 2 * number
        }
        XCTAssertEqual(result, [0, 2, 4, 6, 8, 10])
    }

    func testAsyncCompactMap() async throws {
        let array = [0, 1, 2, 3, 4, 5]
        let result: [Int] = await array.asyncCompactMap { number in
            if number % 2 == 0 {
                return nil
            }
            await Task.yield()
            return 2 * number
        }
        XCTAssertEqual(result, [2, 6, 10])
    }

    func testAsyncFilters() async throws {
        let array = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        let result = await array.asyncFilter { number in
            await Task.yield()
            return number % 2 == 0
        }
        XCTAssertEqual(result, [0, 2, 4, 6, 8])
    }
}
